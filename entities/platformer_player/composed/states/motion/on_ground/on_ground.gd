extends "../motion.gd"


func handle_input(event):
	if event.is_action_pressed("jump"):
		emit_signal("finished", "jump")
	.handle_input(event)


func update(delta):
	if not owner.is_on_floor():
		emit_signal("finished", "fall")
	.update(delta)
