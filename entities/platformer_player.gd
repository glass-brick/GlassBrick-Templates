extends KinematicBody2D

var velocity = Vector2()

export (int) var health = 100

var max_speed = 300
var acceleration = 100
var flipped = false

export (int) var gravity = 1200
var jump_speed = -600
var jump_regulation_frames = 10
var can_double_jump = true
var jump_time = 0
var jumping = false

export (float) var dash_stop = 0.1
export (float) var dash_anim_duration = 0.2
var dash_speed = 1000
var dash_timer = 0
var dash_direction = 1
var dash_jumped = false

export (float) var invincibility_time = 0.5
var invincibility_counter = 0.0
var invincibility = false

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var dash_trail : CPUParticles2D = $Trail
onready var flipped_dash_trail : CPUParticles2D = $TrailFlipped

onready var smp = StateMachine.new(
	self,
	"Floored",
	[
		'Floored',
		'Airborne',
		'Jump',
		'Fall',
		'Crouch',
		'Dash',
		'Dead',
	]
)


func set_health(new_health):
	health = max(new_health, 0)
	if health <= 0:
		smp.travel_to('Dead')


func process_horizontal_move():
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var dash = Input.is_action_just_pressed('dash')

	if (left or right) and not (left and right):
		if right and velocity.x < max_speed:
			velocity.x += acceleration
			if dash_direction == -1:
				dash_timer += dash_stop
		elif left and velocity.x > -max_speed:
			velocity.x -= acceleration
			if dash_direction == 1:
				dash_timer += dash_stop
	else:
		if velocity.x > 0:
			velocity.x = max(velocity.x - acceleration, 0)
		elif velocity.x < 0:
			velocity.x = min(velocity.x + acceleration, 0)
	
	if left:
		flip_left()
	elif right:
		flip_right()

	velocity.x = clamp(velocity.x, -max_speed, max_speed)

	if dash and not (left and right) and (is_on_floor() or not dash_jumped):
		smp.travel_to('Dash')

func flip_left():
	if not flipped:
		flipped = true
		scale.x = -1

func flip_right():
	if flipped:
		flipped = false
		scale.x = -1

func process_jump_input():
	var jump = Input.is_action_pressed('jump')
	var jump_just_pressed = Input.is_action_just_pressed('jump')

	if jump_just_pressed and (is_on_floor() or can_double_jump):
		jumping = true
		jump_time = jump_regulation_frames
		velocity.y = jump_speed
		dash_jumped = false
		if not is_on_floor():
			can_double_jump = false
		animated_sprite.play('Jump' if can_double_jump else 'DoubleJump')

	if jump_time > 0:
		if not jump:
			velocity.y -= jump_speed * jump_time / jump_regulation_frames
			jump_time = 0
			jumping = false
		else:
			jump_time -= 1
			if jump_time == 0:
				jumping = false


func transited_state(_from, to):
	match to:
		"Floored":
			can_double_jump = true
			dash_jumped = false
		"Crouch":
			animated_sprite.play('Crouch')
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
			dash_timer = 0


func process_state(state, delta):
	match state:
		"Airborne":
			if not can_double_jump:
				animated_sprite.play('DoubleJump')
			elif velocity.y > 0:
				animated_sprite.play('Jump')
			else:
				animated_sprite.play('Fall')
			if is_on_floor():
				smp.travel_to('Floored')
		"Crouch":
			var crouch = Input.is_action_pressed('ui_down')
			velocity.x = 0
			if not crouch:
				smp.travel_to('Floored')
		"Dash":
			animated_sprite.play('Dash')
			velocity.y = 0
			velocity.x = dash_direction * dash_speed
			dash_timer += delta
			if dash_timer > dash_anim_duration:
				flipped_dash_trail.emitting = false
				dash_trail.emitting = false
				smp.travel_to("Airborne")
				
	
func physics_process_state(state: String, delta: float):
	match state:
		"Floored", "Airborne":
			if not is_zero_approx(velocity.y):
				smp.travel_to('Airborne')
			process_horizontal_move()
			process_jump_input()
			continue
		"Floored":
			var crouch = Input.is_action_pressed('ui_down')
			animated_sprite.play('Idle' if is_zero_approx(velocity.x) else 'Run')
			if crouch:
				smp.travel_to('Crouch')

	if state != 'Dead':
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

