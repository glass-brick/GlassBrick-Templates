extends Node

var settings_path := "user://settings.json"
var keybindings_key := "keybindings"
var audio_key := "audio"
var initial_settings := {
	keybindings_key: {},
	audio_key: {},
}
var settings := initial_settings


func _enter_tree():
	pause_mode = PAUSE_MODE_PROCESS
	load_settings_to_memory()
	load_keybindings()
	load_audio()


func serialize_input_event(event: InputEvent) -> Dictionary:
	if event is InputEventKey:
		return {"type": "InputEventKey", "scancode": event.scancode}
	elif event is InputEventJoypadButton:
		return {"type": "InputEventJoypadButton", "button_index": event.button_index}
	elif event is InputEventJoypadMotion:
		return {
			"type": "InputEventJoypadMotion", "axis": event.axis, "axis_value": event.axis_value
		}
	elif event is InputEventMouseButton:
		return {"type": "InputEventMouseButton", "button_index": event.button_index}
	return {"type": "Unknown"}


func deserialize_input_event(dict: Dictionary) -> InputEvent:
	var event
	if dict["type"] == "InputEventKey":
		event = InputEventKey.new()
		event.scancode = dict["scancode"]
	elif dict["type"] == "InputEventJoypadButton":
		event = InputEventJoypadButton.new()
		event.button_index = dict["button_index"]
	elif dict["type"] == "InputEventJoypadMotion":
		event = InputEventJoypadMotion.new()
		event.axis = dict["axis"]
		event.axis_value = dict["axis_value"]
	elif dict["type"] == "InputEventMouseButton":
		event = InputEventMouseButton.new()
		event.button_index = dict["button_index"]
	return event


func save_keybindings(action_name: String):
	var binding_list = []
	for input_event in InputMap.get_action_list(action_name):
		binding_list.append(serialize_input_event(input_event))
	save_settings({keybindings_key: {action_name: binding_list}})


func load_keybindings():
	for action_name in settings[keybindings_key]:
		var serialized_actions = settings[keybindings_key][action_name]
		InputMap.action_erase_events(action_name)
		for serialized_action in serialized_actions:
			var event = deserialize_input_event(serialized_action)
			InputMap.action_add_event(action_name, event)


func load_audio():
	var audio_settings: Dictionary = settings[audio_key]
	for bus_name in audio_settings.keys():
		Utils.set_volume(bus_name, audio_settings[bus_name])


func save_audio(bus_name: String, volume: float):
	save_settings({audio_key: {bus_name: volume}})


func save_settings(data_to_save: Dictionary):
	var new_settings = Utils.merge_dicts(settings, data_to_save)
	if to_json(settings) == to_json(new_settings):
		return
	var file = File.new()
	settings = new_settings
	file.open(settings_path, File.WRITE)
	file.store_line(to_json(settings))


func load_settings_to_memory():
	var file = File.new()
	if not file.file_exists(settings_path):
		return
	file.open(settings_path, File.READ)
	settings = Utils.merge_dicts(initial_settings, parse_json(file.get_as_text()))
