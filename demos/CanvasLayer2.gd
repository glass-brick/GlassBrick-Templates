extends CanvasLayer

var paused = false
onready var pause_menu = $PauseMenu


func _ready():
	pause_menu.visible = false


func _unhandled_input(_event):
	if Input.is_action_just_pressed('ui_pause'):
		if not paused:
			pause()
		else:
			unpause()


func pause():
	paused = true
	get_tree().paused = true
	pause_menu.visible = true
	var child = Utils.find_focusable_child(self)
	if child:
		child.grab_focus()


func unpause():
	paused = false
	get_tree().paused = false
	pause_menu.visible = false
