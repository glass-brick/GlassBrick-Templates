extends CanvasLayer

var paused = false
onready var container: Control = $"%PauseMenuContainer"
onready var pause_menu: Control = $"%PauseMenu"
onready var settings_menu: Control = $"%SettingsMenu"
onready var menus = [pause_menu, settings_menu]
onready var mm := MenuManager.new(self, menus, "_on_top_level_back_requested")


func _ready():
	visible = false
	container.release_focus()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed('ui_pause') or (event.is_action_pressed('ui_cancel') and paused):
		get_tree().set_input_as_handled()
		if not paused:
			pause()
		else:
			mm.go_back()


func pause():
	paused = true
	get_tree().paused = true
	visible = true
	mm.open_menu(pause_menu)


func unpause():
	paused = false
	get_tree().paused = false
	visible = false
	mm.close_all()


func _on_Continue_pressed():
	unpause()


func _on_Quit_pressed():
	# quit game, replace with main menu if needed
	mm.quit_game()


func _on_Settings_pressed():
	mm.open_menu(settings_menu)


func _on_SettingsMenu_exited_menu():
	mm.go_back()


func _on_top_level_back_requested():
	unpause()
