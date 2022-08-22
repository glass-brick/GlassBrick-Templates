extends "../motion.gd"


func handle_input(event):
	if InputManager.input_enabled:
		if event.is_action_pressed("jump"):
			emit_signal("finished", "jump")
		elif event.is_action_pressed("dash"):
			emit_signal("finished", "dash")
	.handle_input(event)


func update(delta):
	if not owner.is_on_floor():
		emit_signal("finished", "fall")
	.update(delta)
