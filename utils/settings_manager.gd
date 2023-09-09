extends Node
signal changed

var settings: SettingsResource


func _enter_tree():
	process_mode = PROCESS_MODE_ALWAYS
	settings = SettingsResource.load() if SettingsResource.exists() else SettingsResource.new()
	if settings.version != SettingsResource.CURRENT_VERSION:
		settings = SettingsResource.new()
		settings.write()
	load_settings()
	emit_signal("changed")


func load_settings():
	for action_name in settings.custom_keybindings.keys():
		InputMap.action_erase_events(action_name)
		var input_events = settings.custom_keybindings[action_name]
		for event in input_events:
			InputMap.action_add_event(action_name, event)
	get_window().mode = (
		Window.MODE_EXCLUSIVE_FULLSCREEN
		if (settings.fullscreen)
		else Window.MODE_WINDOWED
	)
	if not (
		(get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN)
		or (get_window().mode == Window.MODE_FULLSCREEN)
	):
		get_window().size = settings.resolution
		get_window().position = (
			(DisplayServer.screen_get_size() - Vector2i(settings.resolution))
			/ 2
		)
	for bus_name in settings.volumes.keys():
		Utils.set_volume(bus_name, settings.volumes[bus_name])


func save_keybindings(action_name: String):
	settings.custom_keybindings[action_name] = InputMap.action_get_events(action_name)
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
	emit_signal("changed")
	settings.write()
