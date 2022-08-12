# Collection of important methods to handle direction and animation
extends "../state.gd"

enum DIRECTIONS { LEFT, RIGHT }
var facing_direction = DIRECTIONS.RIGHT
var velocity = Vector2.ZERO


func get_input_direction():
	return Input.get_axis('ui_left', 'ui_right') if InputManager.input_enabled else 0.0


func get_input_facing_direction():
	var input_direction = get_input_direction()
	if input_direction > 0:
		return DIRECTIONS.RIGHT
	elif input_direction < 0:
		return DIRECTIONS.LEFT
	return null


func opposite(direction):
	return DIRECTIONS.LEFT if direction == DIRECTIONS.RIGHT else DIRECTIONS.RIGHT


func is_facing(direction):
	return facing_direction == direction


func face_direction(direction):
	if direction in DIRECTIONS and not is_facing(direction):
		facing_direction = direction
		owner.scale.x = -1


func flip():
	face_direction(opposite(facing_direction))
