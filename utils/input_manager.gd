extends Node
signal control_mode_changed
signal erased_action_event

# When remapping an input action, if there is a clash, we we'll try to clear it up by overwriting the old action with the new one.
# However, some actions cannot be remapped and are super important (like "ui_left", "ui_accept", etc.).
# Please enter here which actions should be remappable

var safe_remap_actions = ['jump', 'dash']

# This sets the mode that's being used to control the game.
# Might be used to tell which icons to show in the UI, or hide the mouse cursor.

enum CONTROL_MODES { KEYBOARD, CONTROLLER }
var controller_connected = Input.get_connected_joypads().size() > 0
onready var control_mode = (
	CONTROL_MODES.CONTROLLER
	if controller_connected
	else CONTROL_MODES.KEYBOARD
)

const MOUSE_BUTTON_NAMES = {
	BUTTON_LEFT: 'LMB',
	BUTTON_RIGHT: 'RMB',
	BUTTON_MIDDLE: 'Middle mouse button',
	BUTTON_XBUTTON1: 'Mouse button 4',
	BUTTON_XBUTTON2: 'Mouse button 5',
}

const GAMEPAD_BUTTON_IMAGES = {
	JOY_XBOX_A: preload("res://assets/xbox_buttons/a.png"),
	JOY_XBOX_B: preload("res://assets/xbox_buttons/b.png"),
	JOY_XBOX_X: preload("res://assets/xbox_buttons/x.png"),
	JOY_XBOX_Y: preload("res://assets/xbox_buttons/y.png"),
	JOY_DPAD_UP: preload("res://assets/xbox_buttons/d-pad-up.png"),
	JOY_DPAD_DOWN: preload("res://assets/xbox_buttons/d-pad-down.png"),
	JOY_DPAD_LEFT: preload("res://assets/xbox_buttons/d-pad-left.png"),
	JOY_DPAD_RIGHT: preload("res://assets/xbox_buttons/d-pad-right.png"),
	JOY_L: preload("res://assets/xbox_buttons/lb.png"),
	JOY_R: preload("res://assets/xbox_buttons/rb.png"),
	JOY_L2: preload("res://assets/xbox_buttons/lt.png"),
	JOY_R2: preload("res://assets/xbox_buttons/rt.png"),
	JOY_L3: preload("res://assets/xbox_buttons/l3.png"),
	JOY_R3: preload("res://assets/xbox_buttons/r3.png"),
	JOY_SELECT: preload("res://assets/xbox_buttons/select.png"),
	JOY_START: preload("res://assets/xbox_buttons/start.png"),
}

const GAMEPAD_AXIS_IMAGES = {
	JOY_AXIS_0: preload("res://assets/xbox_buttons/l-stick-x-axis.png"),
	JOY_AXIS_1: preload("res://assets/xbox_buttons/l-stick-y-axis.png"),
	JOY_AXIS_2: preload("res://assets/xbox_buttons/r-stick-x-axis.png"),
	JOY_AXIS_3: preload("res://assets/xbox_buttons/r-stick-y-axis.png"),
	JOY_AXIS_6: preload("res://assets/xbox_buttons/lt.png"),
	JOY_AXIS_7: preload("res://assets/xbox_buttons/rt.png"),
}


func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	Input.connect('joy_connection_changed', self, '_on_joy_connection_changed')


func _on_joy_connection_changed(_device, _is_connected, _name, _guid):
	controller_connected = Input.get_connected_joypads().size() > 0


func _input(event: InputEvent):
	if (
		(event is InputEventKey or event is InputEventMouse)
		and control_mode != CONTROL_MODES.KEYBOARD
	):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		control_mode = CONTROL_MODES.KEYBOARD
		emit_signal("control_mode_changed", control_mode)
	elif (
		(event is InputEventJoypadButton or event is InputEventJoypadMotion)
		and control_mode != CONTROL_MODES.CONTROLLER
	):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		control_mode = CONTROL_MODES.CONTROLLER
		emit_signal("control_mode_changed", control_mode)


func get_input_event_node(input_event: InputEvent) -> Control:
	var label_node := Label.new()
	label_node.anchor_bottom = 1.0
	label_node.anchor_right = 1.0
	label_node.valign = Label.ALIGN_CENTER
	label_node.align = Label.ALIGN_CENTER
	var texture_rect := TextureRect.new()
	texture_rect.anchor_bottom = 1.0
	texture_rect.anchor_right = 1.0
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	if input_event == null:
		label_node.text = '[ Unset ]'
	if input_event is InputEventKey:
		label_node.text = OS.get_scancode_string(input_event.get_scancode_with_modifiers())
	elif input_event is InputEventJoypadButton:
		texture_rect.texture = GAMEPAD_BUTTON_IMAGES[input_event.button_index]
		return texture_rect
	elif input_event is InputEventJoypadMotion:
		texture_rect.texture = GAMEPAD_AXIS_IMAGES[input_event.axis]
		return texture_rect
	elif input_event is InputEventMouseButton:
		label_node.text = MOUSE_BUTTON_NAMES[input_event.button_index]
	return label_node


func map_event_to_action(action_name: String, event: InputEvent, previous_event: InputEvent):
	if not action_name in safe_remap_actions:
		return
	for other_action in safe_remap_actions:
		if action_name != other_action and InputMap.event_is_action(event, other_action):
			InputMap.action_erase_event(other_action, event)
			SettingsManager.save_keybindings(other_action)
			emit_signal("erased_action_event", other_action, event)
	InputMap.action_add_event(action_name, event)
	if previous_event:
		InputMap.action_erase_event(action_name, previous_event)
	SettingsManager.save_keybindings(action_name)


func get_action_event(action_name: String, idx: int):
	var bindings = get_action_list(action_name)
	return null if bindings.size() <= idx else bindings[idx]


func get_action_input_node(action_name: String, idx: int) -> Control:
	var input_event = get_action_event(action_name, idx)
	return get_input_event_node(input_event)


func get_action_list(action_name) -> Array:
	var actions = InputMap.get_action_list(action_name)
	var final_actions = []
	for event in actions:
		if (
			(
				control_mode == CONTROL_MODES.KEYBOARD
				and (event is InputEventKey or event is InputEventMouse)
			)
			or (
				control_mode == CONTROL_MODES.CONTROLLER
				and (event is InputEventJoypadButton or event is InputEventJoypadMotion)
			)
		):
			final_actions.append(event)
	return final_actions
