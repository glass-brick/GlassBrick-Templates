extends MarginContainer


func _ready():
	var child = Utils.find_focusable_child(self)
	if child:
		child.grab_focus()
