extends "../motion.gd"


func enter():
	face_axis(get_input_direction())
	owner.get_node("AnimatedSprite").play("Run")


func update(_delta):
	face_axis(get_input_direction())
	owner.velocity.x = get_updated_h_velocity(owner.velocity.x)

	owner.velocity.y = 10  # important for floor check
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	if is_zero_approx(owner.velocity.x):
		emit_signal("finished", "idle")
	if not owner.is_on_floor():
		emit_signal("finished", "fall")
	if InputManager.input_enabled:
		if Input.is_action_just_pressed("dash"):
			emit_signal("finished", "dash")
		if Input.is_action_just_pressed("jump"):
			emit_signal("finished", "jump")
