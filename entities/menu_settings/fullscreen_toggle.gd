extends CheckButton


func _ready():
	connect('toggled', self, '_on_fullscreen_toggle')
	SettingsManager.connect('settings_changed', self, '_on_settings_changed')


func _on_fullscreen_toggle(pressed):
	OS.window_fullscreen = pressed
	SettingsManager.save_fullscreen(pressed)


func _on_settings_changed():
	pressed = OS.window_fullscreen
