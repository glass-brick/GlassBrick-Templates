extends CharacterBody2D

@export var max_speed := 200
@export var acceleration_frames := 5
@export var decceleration_frames := 2
@onready var acceleration = float(max_speed) / float(acceleration_frames)
@onready var decceleration = float(max_speed) / float(decceleration_frames)

@export_range (0, 5, 0.1) var air_time := 1.0
@export_range (0, 20, 0.5) var max_jump_height := 3.0
@export_range (1.0, 5.0) var terminal_velocity := 1.5
@export_range (1.0, 4.0) var wall_jump_speed := 1.5
@onready var player_height = $CollisionShape2D.get_shape().size.y
@onready var jump_speed = -player_height * max_jump_height * 9 / air_time
@onready var gravity = -jump_speed * 2 / air_time
@onready var max_fall_speed = -jump_speed * terminal_velocity
var can_floor_jump = false
var can_double_jump = true
var can_wall_jump = false
var wall_jumped = false
var jump_cancel_time = 0

@export_range(50, 400) var wall_slide_max_speed := 100.0

@export var dash_speed := 500.0
@export_range(0, 0.5) var dash_duration := 0.2
var dash_timer = 0
var dash_jumped = false

@export var acme_time_floor := 0.1
@export var acme_time_wall := 0.2

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_detector : Node2D = $WallDetector
@onready var player_particles: Node2D = $PlayerParticles
@onready var health_component: HealthComponent = $HealthComponent
@onready var interact_component: InteractComponent = $InteractComponent

enum STATES { FLOORED, AIRBORNE, WALLED, DASH, DEAD }

@onready var sm = StateMachine.new(
	self,
	STATES.FLOORED,
	STATES
)

@onready var directions2D : Directions2D = $Directions2D

func _ready():
	health_component.dead.connect(func(): sm.travel_to(STATES.DEAD))

func process_walled_input():
	var direction := Input.get_axis('ui_left', 'ui_right') if InputManager.input_enabled else 0.0
	var jump_just_pressed := Input.is_action_just_pressed('jump') if InputManager.input_enabled else false
	var dash_just_pressed := Input.is_action_just_pressed('dash') if InputManager.input_enabled else false
	can_wall_jump = true
	var is_moving_off_wall = (directions2D.get_axis() < 0 and direction > 0) or (directions2D.get_axis() > 0 and direction < 0)

	if is_on_floor():
		sm.travel_to(STATES.FLOORED)
	elif jump_just_pressed:
		wall_jump()
		directions2D.flip()
		sm.travel_to(STATES.AIRBORNE)
	elif not wall_detector.is_on_wall() or is_moving_off_wall:
		sm.travel_to(STATES.AIRBORNE)
	elif dash_just_pressed:
		sm.travel_to(STATES.DASH)

func wall_jump():
	$Jump.play()
	var jump_direction = directions2D.facing_direction if sm.state == STATES.WALLED else directions2D.opposite(directions2D.facing_direction)

	velocity = Vector2(wall_jump_speed * max_speed * -directions2D.get_axis(jump_direction), jump_speed)
	wall_jumped = true
	can_wall_jump = false

func process_horizontal_move():
	var direction := Input.get_axis('ui_left', 'ui_right') if InputManager.input_enabled else 0.0
	var dash_just_pressed := Input.is_action_just_pressed('dash') if InputManager.input_enabled else false

	if abs(velocity.x) < max_speed:
		wall_jumped = false
	if not is_zero_approx(direction):
		velocity.x = velocity.x + acceleration * direction
		if not wall_jumped:
			velocity.x = clamp(velocity.x, -max_speed * abs(direction), max_speed * abs(direction))
		directions2D.face_axis(direction)
	if wall_jumped or is_zero_approx(direction):
		if velocity.x > 0:
			velocity.x = max(velocity.x - decceleration, 0)
		elif velocity.x < 0:
			velocity.x = min(velocity.x + decceleration, 0)

	if dash_just_pressed and (is_on_floor() or not dash_jumped):
		sm.travel_to(STATES.DASH)
	
	if wall_detector.is_on_wall() and not is_on_floor() and sm.time_since(STATES.WALLED) > acme_time_wall:
		sm.travel_to(STATES.WALLED)

func process_jump_input(delta: float):
	var jump_pressed = Input.is_action_pressed('jump') if InputManager.input_enabled else false
	var jump_just_pressed = Input.is_action_just_pressed('jump') if InputManager.input_enabled else false

	if is_on_floor():
		can_floor_jump = true
	elif sm.time_since(STATES.FLOORED) > acme_time_floor:
		can_floor_jump = false

	if sm.time_since(STATES.WALLED) > acme_time_wall:
		can_wall_jump = false

	if jump_just_pressed and can_wall_jump:
		wall_jump()
	elif jump_just_pressed and (can_floor_jump or can_double_jump):
		velocity.y = jump_speed
		dash_jumped = false
		$Jump.play()
		if can_floor_jump:
			can_floor_jump = false
		elif can_double_jump:
			can_double_jump = false
		animated_sprite.play('Jump' if can_double_jump else 'DoubleJump')
		player_particles.emit_jump_particles()
		jump_cancel_time = air_time / 2.0

	if jump_cancel_time > 0:
		if not jump_pressed:
			velocity.y = 0
			jump_cancel_time = 0
		else:
			jump_cancel_time -= delta

func process_dash(delta):
	dash_timer += delta
	if dash_timer > dash_duration:
		dash_timer = 0
		sm.travel_to(STATES.AIRBORNE)
		velocity.y = 0
		player_particles.stop_emitting_ghost_particles()
	if is_zero_approx(velocity.y) and wall_detector.is_wall_in_front():
		dash_timer = 0
		sm.travel_to(STATES.WALLED)
		player_particles.stop_emitting_ghost_particles()


func transited_state(from, to):
	if to == STATES.FLOORED or to == STATES.WALLED:
		can_double_jump = true
		dash_jumped = false
	match to:
		STATES.WALLED:
			player_particles.start_emitting_wall_slide_particles()
			if wall_detector.is_wall_behind():
				directions2D.flip()
		STATES.FLOORED:
			can_wall_jump = false
		STATES.DEAD:
			velocity = Vector2.ZERO
		STATES.DASH:
			jump_cancel_time = 0
			var direction := Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down') if InputManager.input_enabled else Vector2.ZERO
			player_particles.start_emitting_ghost_particles()
			if(is_zero_approx(direction.x) and is_zero_approx(direction.y)):
				if from == STATES.WALLED:
					directions2D.flip()
				velocity = Vector2(directions2D.get_axis() * dash_speed, 0)
			else:
				if abs(direction.x) > 0.2:
					direction.x = 1 if direction.x > 0 else -1
				else:
					direction.x = 0
				if abs(direction.y) > 0.2:
					direction.y = 1 if direction.y > 0 else -1
				else:
					direction.y = 0
				velocity = Vector2(direction.x, direction.y).normalized() * dash_speed
				directions2D.face_axis(velocity.x)
			if not is_on_floor():
				dash_jumped = true

	match from:
		STATES.WALLED:
			player_particles.stop_emitting_wall_slide_particles()



func _process(_delta):
	match sm.state:
		STATES.FLOORED:
			animated_sprite.play('Idle' if is_zero_approx(velocity.x) else 'Run')
		STATES.AIRBORNE:
			if not can_double_jump:
				animated_sprite.play('DoubleJump')
			elif velocity.y > 0:
				animated_sprite.play('Jump')
			else:
				animated_sprite.play('Fall')
		STATES.WALLED:
			animated_sprite.play('WallSlide')
				
	
func _physics_process(delta: float):
	if sm.state == STATES.FLOORED or sm.state == STATES.AIRBORNE:
		if not is_zero_approx(velocity.y):
			sm.travel_to(STATES.AIRBORNE)
		process_horizontal_move()
		process_jump_input(delta)
	if sm.state == STATES.FLOORED or sm.state == STATES.AIRBORNE or sm.state == STATES.WALLED:
		velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
		if velocity.y > 0:
			jump_cancel_time = 0
	match sm.state:
		STATES.AIRBORNE:
			if is_on_floor():
				sm.travel_to(STATES.FLOORED)
		STATES.DASH:
			process_dash(delta)
		STATES.WALLED:
			velocity.y = clamp(velocity.y, -wall_slide_max_speed, wall_slide_max_speed)
			process_walled_input()

	if sm.state != STATES.DEAD:
		move_and_slide()
		interact_component.check_interactables()
		health_component.process_invincibility(delta)
