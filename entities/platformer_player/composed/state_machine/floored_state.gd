extends State
class_name FlooredState

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var max_speed := 200
@export var acceleration = 2400
@export var decceleration = 6000

@export_range(-2000, 0) var jump_speed := -675

@export var jump_sound : AudioStreamPlayer2D

@export var dash_state : State
@export var airborne_state : State

func state_process(delta):
	var direction := Input.get_axis('ui_left', 'ui_right') if InputManager.input_enabled else 0.0
	var dash_just_pressed := Input.is_action_just_pressed('dash') if InputManager.input_enabled else false

	character.animated_sprite.play('Idle' if is_zero_approx(character.velocity.x) else 'Run')
	
	if not is_zero_approx(direction):
		character.velocity.x = character.velocity.x + acceleration * direction * delta
		character.velocity.x = clamp(character.velocity.x, -max_speed * abs(direction), max_speed * abs(direction))
		character.directions2D.face_axis(direction)
	else:
		if character.velocity.x > 0:
			character.velocity.x = max(character.velocity.x - decceleration * delta, 0)
		elif character.velocity.x < 0:
			character.velocity.x = min(character.velocity.x + decceleration * delta, 0)

	if dash_just_pressed:
		state_machine.travel_to(dash_state)

	var jump_just_pressed = Input.is_action_just_pressed('jump') if InputManager.input_enabled else false

	if jump_just_pressed:
		airborne_state.jump(jump_speed)
		state_machine.travel_to(airborne_state)
		character.animated_sprite.play('Jump')
		character.player_particles.emit_jump_particles()
	
	character.velocity.y += gravity * delta
	if not character.is_on_floor():
		state_machine.travel_to(airborne_state)