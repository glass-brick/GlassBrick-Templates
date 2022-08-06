extends TabContainer

signal exited_menu


func _ready():
	focus_child()


func focus_child():
	var child = Utils.find_focusable_child(get_current_tab_control())
	if child:
		child.grab_focus()


func _on_GoBack_pressed():
	emit_signal("exited_menu")


func _on_ResetDefaults_pressed():
	SettingsManager.reset_defaults()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_next_tab"):
		get_tree().set_input_as_handled()
		current_tab = (current_tab + 1) if current_tab < (get_tab_count() - 1) else 0
		focus_child()
	elif event.is_action_pressed("ui_prev_tab"):
		get_tree().set_input_as_handled()
		current_tab = (current_tab - 1) if current_tab > 0 else (get_tab_count() - 1)
		focus_child()
