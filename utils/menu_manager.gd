class_name MenuManager
extends Control
signal top_level_back_requested

var menus := []
var path := []
var parent = null


func _init(_parent: Node, _menus: Array, _callback_name: String):
	parent = _parent
	parent.add_child(self)
	connect("top_level_back_requested", Callable(parent, _callback_name))
	menus = _menus


func toggle_menu(menu_to_open):
	for menu in menus:
		menu.visible = menu == menu_to_open
		if menu == menu_to_open:
			var child = Utils.find_focusable_child(menu)
			if child:
				child.grab_focus()
			else:
				push_error("No focusable child found in node " + menu.name)


func close_all():
	toggle_menu(null)
	path = []


func open_menu(menu_to_open):
	path.append(menu_to_open)
	toggle_menu(menu_to_open)


func go_back():
	path.pop_back()
	if path.size() == 0:
		emit_signal("top_level_back_requested")
	else:
		toggle_menu(path.back())


func quit_game():
	get_tree().quit()
