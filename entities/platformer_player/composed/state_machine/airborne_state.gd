extends State
class_name AirborneState

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var max_fall_speed = 1000
@export var max_speed := 200
@export var acceleration = 2400
@export var decceleration = 6000
@export_range(-2000, 0) var double_jump_speed := -675
@export var acme_time_wall := 0.2

@export var jump_sound : AudioStreamPlayer2D
@export var dash_state : State
@export var walled_state : State
@export var floored_state : State

var dash_jumped := false
var wall_jumped := false
var can_double_jump := true
var jump_cancel_time := 0.0

func state_process(delta):
	var direction := Input.get_axis('ui_left', 'ui_right') if InputManager.input_enabled else 0.0
	var dash_just_pressed := Input.is_action_just_pressed('dash') if InputManager.input_enabled else false

	if abs(character.velocity.x) < max_speed:
		wall_jumped = false
	if not is_zero_approx(direction):
		character.velocity.x = character.velocity.x + acceleration * direction * delta
		character.velocity.x = clamp(character.velocity.x, -max_speed * abs(direction), max_speed * abs(direction))
		character.directions2D.face_axis(direction)
	if wall_jumped or is_zero_approx(direction):
		if character.velocity.x > 0:
			character.velocity.x = max(character.velocity.x - decceleration * delta, 0)
		elif character.velocity.x < 0:
			character.velocity.x = min(character.velocity.x + decceleration * delta, 0)

	if dash_just_pressed and not dash_jumped:
		state_machine.travel_to(dash_state)
	
	if character.wall_detector.is_on_wall() and state_machine.time_since(walled_state) > acme_time_wall:
		state_machine.travel_to(walled_state)

	var jump_pressed = Input.is_action_pressed('jump') if InputManager.input_enabled else false
	var jump_just_pressed = Input.is_action_just_pressed('jump') if InputManager.input_enabled else false

	if jump_just_pressed and can_double_jump:
		jump(double_jump_speed)
		character.animated_sprite.play('DoubleJump')
		can_double_jump = false

	# jump cancel
	if jump_cancel_time > 0:
		if not jump_pressed:
			character.velocity.y = 0
			jump_cancel_time = 0.0
		else:
			jump_cancel_time -= delta
	
	if character.is_on_floor():
		state_machine.travel_to(floored_state)
	
	if character.animated_sprite.animation == "Jump" and character.velocity.y > 0:
		character.animated_sprite.play("Fall")
	
	character.velocity.y = min(character.velocity.y + gravity * delta, max_fall_speed)

func on_exit():
	if state_machine.next_state == floored_state or state_machine.next_state == walled_state:
		dash_jumped = false
		wall_jumped = false
		can_double_jump = true
		jump_cancel_time = 0.0

func jump(speed : float):
	jump_cancel_time = -speed / gravity
	character.velocity.y = speed
	character.player_particles.emit_jump_particles()
	if jump_sound:
		jump_sound.play()
