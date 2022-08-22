# Collection of important methods to handle direction and animation
extends "../state.gd"


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
