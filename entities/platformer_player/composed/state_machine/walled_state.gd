extends State
class_name WalledState

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export_range(50, 400) var wall_slide_max_speed := 100.0
@export var wall_jump_speed = Vector2(200, -675)

@export var jump_sound : AudioStreamPlayer2D
@export var dash_state : State
@export var airborne_state : State
@export var floored_state : State

func state_process(delta):
	var direction := Input.get_axis('ui_left', 'ui_right') if InputManager.input_enabled else 0.0
	var jump_just_pressed := Input.is_action_just_pressed('jump') if InputManager.input_enabled else false
	var dash_just_pressed := Input.is_action_just_pressed('dash') if InputManager.input_enabled else false
	var is_moving_off_wall = (character.directions2D.get_axis() < 0 and direction > 0) or (character.directions2D.get_axis() > 0 and direction < 0)

	if character.is_on_floor():
		state_machine.travel_to(floored_state)
	elif jump_just_pressed:
		wall_jump()
		character.directions2D.flip()
	elif not character.wall_detector.is_on_wall() or is_moving_off_wall:
		state_machine.travel_to(airborne_state)
	elif dash_just_pressed:
		character.directions2D.flip()
		state_machine.travel_to(dash_state)
	
	character.velocity.y = clamp(character.velocity.y + gravity * delta, -wall_slide_max_speed, wall_slide_max_speed)

func wall_jump():
	if jump_sound:
		jump_sound.play()
	var jump_direction = character.directions2D.facing_direction if state_machine.current_state == self else character.directions2D.opposite(character.directions2D.facing_direction)

	character.velocity = Vector2(wall_jump_speed.x * -character.directions2D.get_axis(jump_direction), wall_jump_speed.y)
	character.animated_sprite.play("Jump")
	airborne_state.wall_jumped = true
	state_machine.travel_to(airborne_state)

func on_enter():
	character.animated_sprite.play('WallSlide')
	character.player_particles.start_emitting_wall_slide_particles()
	if character.wall_detector.is_wall_behind():
		character.directions2D.flip()

func on_exit():
	character.player_particles.stop_emitting_wall_slide_particles()
