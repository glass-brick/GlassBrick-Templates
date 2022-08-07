extends Control

signal exited_menu

onready var tab_container: TabContainer = $"%TabContainer"


func _ready():
	focus_child()


func focus_child():
	var child = Utils.find_focusable_child(tab_container.get_current_tab_control())
	if child:
		child.grab_focus()


func _on_GoBack_pressed():
	emit_signal("exited_menu")


func _on_ResetDefaults_pressed():
	SettingsManager.reset_defaults()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_next_tab"):
		get_tree().set_input_as_handled()
		tab_container.current_tab = (
			(tab_container.current_tab + 1)
			if tab_container.current_tab < (tab_container.get_tab_count() - 1)
			else 0
		)
	elif event.is_action_pressed("ui_prev_tab"):
		get_tree().set_input_as_handled()
		tab_container.current_tab = (
			(tab_container.current_tab - 1)
			if tab_container.current_tab > 0
			else (tab_container.get_tab_count() - 1)
		)


func _on_SettingsMenu_tab_changed(_tab: int):
	focus_child()
