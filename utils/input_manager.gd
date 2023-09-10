extends Node
signal controls_changed
signal control_mode_changed
signal erased_action_event

# When remapping an input action, if there is a clash, we we'll try to clear it up by overwriting the old action with the new one.
# However, some actions cannot be remapped and are super important (like "ui_left", "ui_accept", etc.).
# Please enter here which actions should be remappable

var safe_remap_actions = ['jump', 'dash', 'interact']

# This is just a flag to indicate if the player is in a state where he can't be controlled.

var input_enabled = true

# This sets the mode that's being used to control the game.
# Might be used to tell which icons to show in the UI, or hide the mouse cursor.

enum CONTROL_MODES { KEYBOARD, CONTROLLER }
var controller_connected = Input.get_connected_joypads().size() > 0
@onready var control_mode = (
	CONTROL_MODES.CONTROLLER
	if controller_connected
	else CONTROL_MODES.KEYBOARD
)


func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	Input.connect('joy_connection_changed', Callable(self, '_on_joy_connection_changed'))


func _on_joy_connection_changed(_device, _is_connected, _name, _guid):
	controller_connected = Input.get_connected_joypads().size() > 0


func _input(event: InputEvent):
	if (
		(event is InputEventKey or event is InputEventMouse)
		and control_mode != CONTROL_MODES.KEYBOARD
	):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		control_mode = CONTROL_MODES.KEYBOARD
		emit_signal("control_mode_changed")
		emit_signal("controls_changed")
	elif (
		(event is InputEventJoypadButton or event is InputEventJoypadMotion)
		and control_mode != CONTROL_MODES.CONTROLLER
	):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		control_mode = CONTROL_MODES.CONTROLLER
		emit_signal("control_mode_changed")
		emit_signal("controls_changed")


func get_input_event_display_resource(input_event: InputEvent):
	if input_event == null:
		return '[ Unset ]'
	if input_event is InputEventKey:
		var keycode: int = input_event.keycode
		return (
			InputResources.KEYBOARD_RESOURCES[keycode]
			if keycode in InputResources.KEYBOARD_RESOURCES
			else OS.get_keycode_string(keycode)
		)
	if input_event is InputEventJoypadButton:
		return InputResources.GAMEPAD_BUTTON_RESOURCES[input_event.button_index]
	if input_event is InputEventJoypadMotion:
		var dictionary: Dictionary = InputResources.GAMEPAD_AXIS_RESOURCES[input_event.axis]
		if input_event.axis_value > 0 and "positive" in dictionary:
			return dictionary["positive"]
		elif input_event.axis_value < 0 and "negative" in dictionary:
			return dictionary["negative"]
		return dictionary["generic"]
	if input_event is InputEventMouseButton:
		return InputResources.MOUSE_BUTTON_RESOURCES[input_event.button_index]
	return '[ Unknown ]'


func get_input_event_node(input_event: InputEvent) -> Control:
	var display_resource = get_input_event_display_resource(input_event)
	if display_resource is String:
		var label_node := Label.new()
		label_node.anchor_bottom = 1.0
		label_node.anchor_right = 1.0
		label_node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label_node.text = display_resource
		return label_node
	if display_resource is Texture2D:
		var texture_rect := TextureRect.new()
		texture_rect.anchor_bottom = 1.0
		texture_rect.anchor_right = 1.0
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		texture_rect.texture = display_resource
		return texture_rect
	return Control.new()


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
	emit_signal("controls_changed")
	SettingsManager.save_keybindings(action_name)


func get_action_event(action_name: String, idx: int):
	var bindings = action_get_events(action_name)
	return null if bindings.size() <= idx else bindings[idx]


func get_action_input_node(action_name: String, idx: int) -> Control:
	var input_event = get_action_event(action_name, idx)
	return get_input_event_node(input_event)


func get_action_display_resource(action_name: String, idx: int):
	var input_event = get_action_event(action_name, idx)
	return get_input_event_display_resource(input_event)


func action_get_events(action_name) -> Array:
	var actions = InputMap.action_get_events(action_name)
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


func disable_input():
	input_enabled = false


func enable_input():
	input_enabled = true
