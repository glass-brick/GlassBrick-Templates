extends CanvasLayer

var paused = false
onready var pause_menu: Control = $PauseMenu


func _ready():
	pause_menu.visible = false
	pause_menu.release_focus()


func _unhandled_input(_event):
	if Input.is_action_just_pressed('ui_pause'):
		if not paused:
			pause()
		else:
			unpause()
	if Input.is_action_just_pressed('ui_cancel'):
		unpause()


func pause():
	get_tree().set_input_as_handled()
	paused = true
	get_tree().paused = true
	pause_menu.visible = true
	var child = Utils.find_focusable_child(pause_menu)
	if child:
		child.grab_focus()


func unpause():
	get_tree().set_input_as_handled()
	paused = false
	get_tree().paused = false
	pause_menu.visible = false
