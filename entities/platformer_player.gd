extends KinematicBody2D

var velocity = Vector2()

export (int) var health = 100

export (int) var max_speed = 200
export (int) var acceleration_frames = 5
export (int) var decceleration_frames = 2
onready var acceleration = float(max_speed) / float(acceleration_frames)
onready var decceleration = float(max_speed) / float(decceleration_frames)
var flipped = false

export (float, 0, 5, 0.1) var air_time = 1
export (float, 0, 20, 0.5) var max_jump_height = 3.0
onready var player_height = $CollisionShape2D.get_shape().get_extents().y
onready var jump_speed = -player_height * max_jump_height * 9 / air_time
onready var gravity = -jump_speed * 2 / air_time
var can_floor_jump = false
var can_double_jump = true
var jump_cancel_time = 0

export (float) var dash_speed = 1000
export (float, 0, 0.5) var dash_duration = 0.2
var dash_timer = 0
var dash_direction = 1
var dash_jumped = false

export (float) var invincibility_time = 0.5
var invincibility_counter = 0.0
var invincibility = false

export (float) var acme_time = 0.1

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var dash_trail : CPUParticles2D = $Trail
onready var flipped_dash_trail : CPUParticles2D = $TrailFlipped

onready var smp = StateMachine.new(
	self,
	"Floored",
	[
		'Floored',
		'Airborne',
		'Dash',
		'Dead',
	]
)

func set_health(new_health):
	health = max(new_health, 0)
	if health <= 0:
		smp.travel_to('Dead')


func process_horizontal_move():
	var direction := Input.get_axis('ui_left', 'ui_right')
	var dash_just_pressed := Input.is_action_just_pressed('dash')

	if not is_zero_approx(direction):
		velocity.x = clamp(velocity.x + acceleration * direction, -max_speed * abs(direction), max_speed * abs(direction))
		if direction > 0:
			flip_right()
		else:
			flip_left()
	else:
		if velocity.x > 0:
			velocity.x = max(velocity.x - decceleration, 0)
		elif velocity.x < 0:
			velocity.x = min(velocity.x + decceleration, 0)

	if dash_just_pressed and (is_on_floor() or not dash_jumped):
		smp.travel_to('Dash')

func flip_left():
	if not flipped:
		flipped = true
		scale.x = -1

func flip_right():
	if flipped:
		flipped = false
		scale.x = -1

func process_jump_input(delta: float):
	var jump_pressed = Input.is_action_pressed('jump')
	var jump_just_pressed = Input.is_action_just_pressed('jump')

	if is_on_floor():
		can_floor_jump = true
	elif smp.time_since("Floored") > acme_time:
		can_floor_jump = false

	if jump_just_pressed and (can_floor_jump or can_double_jump):
		velocity.y = jump_speed
		dash_jumped = false
		if can_floor_jump:
			can_floor_jump = false
		elif can_double_jump:
			can_double_jump = false
		animated_sprite.play('Jump' if can_double_jump else 'DoubleJump')
		jump_cancel_time = air_time / 2.0

	if jump_cancel_time > 0:
		if not jump_pressed:
			velocity.y = 0
			jump_cancel_time = 0
		else:
			jump_cancel_time -= delta


func transited_state(_from, to):
	match to:
		"Floored":
			can_double_jump = true
			dash_jumped = false
		"Dead":
			health = 0
			velocity = Vector2()
		"Dash":
			if flipped:
				flipped_dash_trail.emitting = true
			else:
				dash_trail.emitting = true
			dash_direction = -1 if flipped else 1
			if not is_on_floor():
				dash_jumped = true


func _process(delta):
	match smp.state:
		"Airborne":
			if not can_double_jump:
				animated_sprite.play('DoubleJump')
			elif velocity.y > 0:
				animated_sprite.play('Jump')
			else:
				animated_sprite.play('Fall')
			if is_on_floor():
				smp.travel_to('Floored')
		"Dash":
			animated_sprite.play('Dash')
			velocity.y = 0
			velocity.x = dash_direction * dash_speed
			dash_timer += delta
			if dash_timer > dash_duration:
				dash_timer = 0
				flipped_dash_trail.emitting = false
				dash_trail.emitting = false
				smp.travel_to("Airborne")
				
	
func _physics_process(delta: float):
	match smp.state:
		"Floored", "Airborne":
			if not is_zero_approx(velocity.y):
				smp.travel_to('Airborne')
			process_horizontal_move()
			process_jump_input(delta)
			continue
		"Floored":
			animated_sprite.play('Idle' if is_zero_approx(velocity.x) else 'Run')

	if smp.state != 'Dead':
		velocity.y += gravity * delta
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
	if not invincibility and smp.state != 'Dead':
		set_health(health - damage)
		invincibility = true

