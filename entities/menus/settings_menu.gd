extends MarginContainer

signal exited_menu


func _ready():
	var child = Utils.find_focusable_child(self)
	if child:
		child.grab_focus()


func _on_GoBack_pressed():
	emit_signal("exited_menu")


func _on_ResetDefaults_pressed():
	SettingsManager.reset_defaults()
