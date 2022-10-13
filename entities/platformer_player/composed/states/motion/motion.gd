# Collection of important methods to handle direction and animation
extends "../state.gd"

export (int) var max_speed = 200
export (int) var acceleration_frames = 5
export (int) var decceleration_frames = 2
onready var acceleration = float(max_speed) / float(acceleration_frames)
onready var decceleration = float(max_speed) / float(decceleration_frames)


func get_input_direction():
	return Input.get_axis('ui_left', 'ui_right') if InputManager.input_enabled else 0.0


func face_axis(axis: float):
	if axis > 0.0:
		face_direction(Vector2.RIGHT)
	elif axis < 0.0:
		face_direction(Vector2.LEFT)


func face_direction(direction: Vector2):
	var is_direction_valid = direction == Vector2.RIGHT or direction == Vector2.LEFT
	if is_direction_valid and not owner.facing_direction == direction:
		owner.facing_direction = direction
		owner.scale.x *= -1


func flip():
	face_direction(Vector2.LEFT if owner.facing_direction.x > 0 else Vector2.RIGHT)


func get_updated_h_velocity(velocity_x: float) -> float:
	var input_direction = get_input_direction()
	if not is_zero_approx(input_direction):
		# important for controller stick velocity management
		var input_max_speed = max_speed * abs(input_direction)
		return clamp(velocity_x + acceleration * input_direction, -input_max_speed, input_max_speed)
	else:
		return move_toward(velocity_x, 0, decceleration)
