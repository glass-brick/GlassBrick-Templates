extends Control
class_name MenuOption

export (NodePath) var label_path: NodePath setget set_label_path
export (Color) var focus_color := Color(1, 1, 0.7, 1)
export (Color) var selected_color := Color.yellow
export (bool) var exit_with_accept := false
var in_option := false
var label: Label


func _enter_tree():
	focus_mode = FOCUS_ALL
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")


func _gui_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		accept_event()
		select_option()


func _unhandled_input(event: InputEvent):
	if (
		in_option
		and (
			event.is_action_pressed("ui_cancel")
			or (exit_with_accept and event.is_action_pressed("ui_accept"))
		)
	):
		get_tree().set_input_as_handled()
		unselect_option()


func _process(_delta):
	if not is_visible_in_tree():
		return
	if in_option and get_focus_owner() != null and not Utils.is_child_focused(self):
		unselect_option()
	elif not in_option and Utils.is_child_focused(self):
		select_option()


func set_label_path(path: NodePath):
	if not is_inside_tree():
		yield(self, 'ready')
	label = get_node(path)


func select_option():
	var child = Utils.find_focusable_child(self)
	if child:
		in_option = true
		child.grab_focus()


func unselect_option():
	in_option = false
	grab_focus()


func _on_focus_entered():
	label.modulate = focus_color


func _on_focus_exited():
	if in_option:
		label.modulate = selected_color
	else:
		label.modulate = Color.white
