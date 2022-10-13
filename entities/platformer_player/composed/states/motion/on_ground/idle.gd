extends "../motion.gd"


func enter():
	owner.get_node("AnimatedSprite").play("Idle")


func update(_delta):
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", "move")
	if InputManager.input_enabled:
		if Input.is_action_just_pressed("dash"):
			emit_signal("finished", "dash")
		if Input.is_action_just_pressed("jump"):
			emit_signal("finished", "jump")
