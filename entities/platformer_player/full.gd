extends KinematicBody2D

var velocity = Vector2()

export (int) var health = 100

export (int) var max_speed = 200
export (int) var acceleration_frames = 5
export (int) var decceleration_frames = 2
onready var acceleration = float(max_speed) / float(acceleration_frames)
onready var decceleration = float(max_speed) / float(decceleration_frames)

enum DIRECTIONS { LEFT, RIGHT }
var facing_direction = DIRECTIONS.RIGHT

export (float, 0, 5, 0.1) var air_time = 1
export (float, 0, 20, 0.5) var max_jump_height = 3.0
export (float, 1.0, 5.0) var terminal_velocity = 1.5
export (float, 1.0, 4.0) var wall_jump_speed = 1.5
onready var player_height = $CollisionShape2D.get_shape().get_extents().y
onready var jump_speed = -player_height * max_jump_height * 9 / air_time
onready var gravity = -jump_speed * 2 / air_time
onready var max_fall_speed = -jump_speed * terminal_velocity
var can_floor_jump = false
var can_double_jump = true
var can_wall_jump = false
var wall_jumped = false
var jump_cancel_time = 0

export (float, 50, 400) var wall_slide_max_speed = 100

export (float) var dash_speed = 500
export (float, 0, 0.5) var dash_duration = 0.2
var dash_timer = 0
var dash_jumped = false

export (float) var invincibility_time = 0.5
var invincibility_counter = 0.0
var invincibility = false

export (float) var acme_time_floor = 0.1
export (float) var acme_time_wall = 0.2

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var wall_detector : Node2D = $WallDetector
onready var player_particles: Node2D = $PlayerParticles

enum STATES { FLOORED, AIRBORNE, WALLED, DASH, DEAD }

onready var sm = StateMachine.new(
	self,
	STATES.FLOORED,
	STATES
)

onready var interactable_area : Area2D = $InteractableDetectionArea
var interactables := []
var interactable_target : Interactable

func _ready():
	# fix camera jitter https://godotengine.org/qa/24510/camera2d-smoothing-jitter-in-godot-3-0
	Engine.set_target_fps(Engine.get_iterations_per_second())

func set_health(new_health):
	health = max(new_health, 0)
	if health <= 0:
		sm.travel_to(STATES.DEAD)

func process_walled_input():
	var direction := Input.get_axis('ui_left', 'ui_right') if InputManager.input_enabled else 0.0
	var jump_just_pressed := Input.is_action_just_pressed('jump') if InputManager.input_enabled else false
	var dash_just_pressed := Input.is_action_just_pressed('dash') if InputManager.input_enabled else false
	can_wall_jump = true
	var is_moving_off_wall = (is_facing(DIRECTIONS.LEFT) and direction > 0) or (is_facing(DIRECTIONS.RIGHT) and direction < 0)

	if is_on_floor():
		sm.travel_to(STATES.FLOORED)
	elif jump_just_pressed:
		wall_jump()
		flip()
		sm.travel_to(STATES.AIRBORNE)
	elif not wall_detector.is_on_wall() or is_moving_off_wall:
		sm.travel_to(STATES.AIRBORNE)
	elif dash_just_pressed:
		sm.travel_to(STATES.DASH)

func wall_jump():
	$Jump.play()
	var jump_direction = facing_direction if sm.state == STATES.WALLED else opposite(facing_direction)

	velocity = Vector2(wall_jump_speed * max_speed * (1 if jump_direction == DIRECTIONS.LEFT else -1), jump_speed)
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
		if direction > 0:
			face_right()
		else:
			face_left()
	if wall_jumped or is_zero_approx(direction):
		if velocity.x > 0:
			velocity.x = max(velocity.x - decceleration, 0)
		elif velocity.x < 0:
			velocity.x = min(velocity.x + decceleration, 0)

	if dash_just_pressed and (is_on_floor() or not dash_jumped):
		sm.travel_to(STATES.DASH)

	if wall_detector.is_on_wall() and not is_on_floor() and sm.time_since(STATES.WALLED) > acme_time_wall:
		sm.travel_to(STATES.WALLED)

func opposite(direction):
	return DIRECTIONS.LEFT if direction == DIRECTIONS.RIGHT else DIRECTIONS.RIGHT

func is_facing(direction):
	return facing_direction == direction

func flip():
	if is_facing(DIRECTIONS.LEFT):
		face_right()
	else:
		face_left()

func face_left():
	if is_facing(DIRECTIONS.RIGHT):
		facing_direction = DIRECTIONS.LEFT
		scale.x = -1

func face_right():
	if is_facing(DIRECTIONS.LEFT):
		facing_direction = DIRECTIONS.RIGHT
		scale.x = -1

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
	match to:
		STATES.FLOORED, STATES.WALLED:
			can_double_jump = true
			dash_jumped = false
			continue
		STATES.WALLED:
			player_particles.start_emitting_wall_slide_particles()
			if wall_detector.is_wall_behind():
				flip()
		STATES.FLOORED:
			can_wall_jump = false
		STATES.DEAD:
			health = 0
			velocity = Vector2()
		STATES.DASH:
			jump_cancel_time = 0
			var direction := Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down') if InputManager.input_enabled else Vector2.ZERO
			player_particles.start_emitting_ghost_particles()
			if(is_zero_approx(direction.x) and is_zero_approx(direction.y)):
				if from == STATES.WALLED:
					flip()
				velocity = Vector2((-1 if is_facing(DIRECTIONS.LEFT) else 1) * dash_speed, 0)
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
				if velocity.x > 0:
					face_right()
				elif velocity.x < 0:
					face_left()
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
	match sm.state:
		STATES.FLOORED, STATES.AIRBORNE:
			if not is_zero_approx(velocity.y):
				sm.travel_to(STATES.AIRBORNE)
			process_horizontal_move()
			process_jump_input(delta)
			continue
		STATES.FLOORED, STATES.AIRBORNE, STATES.WALLED:
			velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
			if velocity.y > 0:
				jump_cancel_time = 0
			continue
		STATES.AIRBORNE:
			if is_on_floor():
				sm.travel_to(STATES.FLOORED)
		STATES.DASH:
			process_dash(delta)
		STATES.WALLED:
			velocity.y = clamp(velocity.y, -wall_slide_max_speed, wall_slide_max_speed)
			process_walled_input()

	if sm.state != STATES.DEAD:
		velocity = move_and_slide(velocity, Vector2(0, -1))
		check_interactables()
		process_invincibility(delta)

func process_invincibility(delta):
	if invincibility:
		invincibility_counter += delta
		var mat = animated_sprite.get_material()
		mat.set_shader_param("active", true)
		if invincibility_counter > invincibility_time:
			invincibility = false
	else:
		invincibility_counter = 0
		var mat = animated_sprite.get_material()
		mat.set_shader_param("active", false)


func _on_hit(damage, _damager):
	if not invincibility and sm.state != STATES.DEAD:
		set_health(health - damage)
		invincibility = true

func _on_InteractableDetectionArea_area_exited(area:Area2D):
	if area is Interactable:
		if area == interactable_target:
			area.unset_target()
			interactable_target = null
		interactables.erase(area)

func _on_InteractableDetectionArea_area_entered(area:Area2D):
	if area is Interactable:
		interactables.append(area)

func check_interactables():
	var closest_distance := INF
	var closest_interactable : Interactable = null
	for interactable in interactables:
		var distance = (interactable.get_global_position() - get_global_position()).length()
		if interactable.enabled and distance < closest_distance:
			closest_distance = distance
			closest_interactable = interactable
	if closest_interactable != interactable_target:
		if interactable_target:
			interactable_target.unset_target()
		interactable_target = closest_interactable
		if interactable_target:
			interactable_target.set_target()
