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
onready var player_height = $CollisionShape2D.get_shape().get_extents().y
onready var jump_speed = -player_height * max_jump_height * 9 / air_time
onready var gravity = -jump_speed * 2 / air_time
onready var max_fall_speed = -jump_speed * terminal_velocity
var can_floor_jump = false
var can_double_jump = true
var jump_cancel_time = 0

export (float) var invincibility_time = 0.5
var invincibility_counter = 0.0
var invincibility = false

export (float) var acme_time_floor = 0.1

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var player_particles: Node2D = $PlayerParticles

enum STATES { FLOORED, AIRBORNE, DEAD }

onready var sm = StateMachine.new(
	self,
	STATES.FLOORED,
	STATES
)

func set_health(new_health):
	health = max(new_health, 0)
	if health <= 0:
		sm.travel_to(STATES.DEAD)

func process_horizontal_move():
	var direction := Input.get_axis('ui_left', 'ui_right')

	if not is_zero_approx(direction):
		velocity.x = velocity.x + acceleration * direction
		velocity.x = clamp(velocity.x, -max_speed * abs(direction), max_speed * abs(direction))
		if direction > 0:
			face_right()
		else:
			face_left()
	if is_zero_approx(direction):
		if velocity.x > 0:
			velocity.x = max(velocity.x - decceleration, 0)
		elif velocity.x < 0:
			velocity.x = min(velocity.x + decceleration, 0)

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
	var jump_pressed = Input.is_action_pressed('jump')
	var jump_just_pressed = Input.is_action_just_pressed('jump')

	if is_on_floor():
		can_floor_jump = true
	elif sm.time_since(STATES.FLOORED) > acme_time_floor:
		can_floor_jump = false

	if jump_just_pressed and (can_floor_jump or can_double_jump):
		velocity.y = jump_speed
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


func transited_state(_from, to):
	match to:
		STATES.FLOORED:
			can_double_jump = true
		STATES.DEAD:
			health = 0
			velocity = Vector2()


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
			if is_on_floor():
				sm.travel_to(STATES.FLOORED)
				
	
func _physics_process(delta: float):
	match sm.state:
		STATES.FLOORED, STATES.AIRBORNE:
			if not is_zero_approx(velocity.y):
				sm.travel_to(STATES.AIRBORNE)
			process_horizontal_move()
			process_jump_input(delta)
			velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
			if velocity.y > 0:
				jump_cancel_time = 0

	if sm.state != STATES.DEAD:
		velocity = move_and_slide(velocity, Vector2(0, -1))
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

