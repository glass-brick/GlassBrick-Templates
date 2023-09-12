extends State
class_name DashState

@export var dash_speed := 500.0
@export_range(0, 0.5) var dash_duration := 0.2
var dash_timer = 0

@export var airborne_state : State
@export var walled_state : State
@export var floored_state : State

func state_process(delta):
	dash_timer += delta
	if dash_timer > dash_duration:
		dash_timer = 0
		state_machine.travel_to(airborne_state)
		airborne_state.dash_jumped = true
		character.velocity.y = 0
	if is_zero_approx(character.velocity.y) and character.wall_detector.is_wall_in_front():
		dash_timer = 0
		state_machine.travel_to(walled_state)

func on_exit():
	character.player_particles.stop_emitting_ghost_particles()

func on_enter():
	character.player_particles.start_emitting_ghost_particles()

	var direction := Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down') if InputManager.input_enabled else Vector2.ZERO
	if(is_zero_approx(direction.x) and is_zero_approx(direction.y)):
		character.velocity = Vector2(character.directions2D.get_axis() * dash_speed, 0)
	else:
		if abs(direction.x) > 0.2:
			direction.x = 1 if direction.x > 0 else -1
		else:
			direction.x = 0
		if abs(direction.y) > 0.2:
			direction.y = 1 if direction.y > 0 else -1
		else:
			direction.y = 0
		character.velocity = Vector2(direction.x, direction.y).normalized() * dash_speed
		character.directions2D.face_axis(character.velocity.x)