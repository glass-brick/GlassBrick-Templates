# Collection of important methods to handle direction and animation
extends "../state.gd"


func get_input_direction():
	return Input.get_axis('ui_left', 'ui_right') if InputManager.input_enabled else 0.0
