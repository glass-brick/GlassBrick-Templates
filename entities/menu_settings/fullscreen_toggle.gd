extends MenuOption
@onready var checkbox: CheckBox = $"%CheckBox"


func _ready():
	SettingsManager.connect('changed', Callable(self, '_on_settings_changed'))


func _on_settings_changed():
	checkbox.button_pressed = ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))


func _on_CheckBox_toggled(pressed: bool):
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (pressed) else Window.MODE_WINDOWED
	SettingsManager.save_fullscreen(pressed)
