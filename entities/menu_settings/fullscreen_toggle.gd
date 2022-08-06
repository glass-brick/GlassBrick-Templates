extends MenuOption
onready var checkbox: CheckBox = $"%CheckBox"


func _ready():
	SettingsManager.connect('settings_changed', self, '_on_settings_changed')


func _on_settings_changed():
	checkbox.pressed = OS.window_fullscreen


func _on_CheckBox_toggled(pressed: bool):
	OS.window_fullscreen = pressed
	SettingsManager.save_fullscreen(pressed)
