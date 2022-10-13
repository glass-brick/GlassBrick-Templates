extends Node
signal settings_changed

var settings: SettingsResource


func _enter_tree():
	pause_mode = PAUSE_MODE_PROCESS
	settings = SettingsResource.load() if SettingsResource.exists() else SettingsResource.new()
	if settings.version != SettingsResource.CURRENT_VERSION:
		settings = SettingsResource.new()
		settings.write()
	load_settings()
	emit_signal("settings_changed")


func load_settings():
	for action_name in settings.custom_keybindings.keys():
		InputMap.action_erase_events(action_name)
		var input_events = settings.custom_keybindings[action_name]
		for event in input_events:
			InputMap.action_add_event(action_name, event)
	OS.window_fullscreen = settings.fullscreen
	if not OS.window_fullscreen:
		OS.window_size = settings.resolution
		OS.window_position = (OS.get_screen_size() - settings.resolution) / 2
	for bus_name in settings.volumes.keys():
		Utils.set_volume(bus_name, settings.volumes[bus_name])


func save_keybindings(action_name: String):
	settings.custom_keybindings[action_name] = InputMap.get_action_list(action_name)
	settings.write()


func save_audio(bus_name: String, volume: float):
	settings[bus_name] = volume
	settings.write()


func save_fullscreen(is_fullscreen: bool):
	settings.fullscreen = is_fullscreen
	settings.write()


func save_resolution(resolution: Vector2):
	settings.resolution = resolution
	settings.write()


func reset_defaults():
	settings = SettingsResource.new()
	load_settings()
	emit_signal("settings_changed")
	settings.write()
