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
	load_settings_to_memory()
	load_keybindings()
	load_audio()


func save_keybindings(action_name: String):
	var binding_list = []
	for key_event in InputMap.get_action_list(action_name):
		binding_list.append(key_event.scancode)
	save_settings({keybindings_key: {action_name: binding_list}})


func load_keybindings():
	for action_name in settings[keybindings_key]:
		var binding_list = settings[keybindings_key][action_name]
		InputMap.action_erase_events(action_name)
		for scancode in binding_list:
			var key_event = InputEventKey.new()
			key_event.scancode = scancode
			InputMap.action_add_event(action_name, key_event)


func load_audio():
	var audio_settings: Dictionary = settings[audio_key]
	for audio_type in audio_settings:
		AudioManager.set_volume(audio_settings[audio_type], audio_type)


func save_audio(audio_type: String, volume: float):
	var audio_settings: Dictionary = settings[audio_key]
	audio_settings[audio_type] = volume
	save_settings({audio_key: audio_settings})


func save_settings(data_to_save: Dictionary):
	var file = File.new()
	settings = Utils.merge_dicts(settings, data_to_save)
	file.open(settings_path, File.WRITE)
	file.store_line(to_json(settings))
	print(settings)


func load_settings_to_memory():
	var file = File.new()
	if not file.file_exists(settings_path):
		return
	file.open(settings_path, File.READ)
	settings = Utils.merge_dicts(initial_settings, parse_json(file.get_line()))
