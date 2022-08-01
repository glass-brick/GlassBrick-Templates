extends CheckButton


func _ready():
	connect('toggled', self, '_on_fullscreen_toggle')


func _on_fullscreen_toggle(pressed):
	OS.window_fullscreen = pressed
	SettingsManager.save_fullscreen(pressed)
