extends '../motion.gd'

export (float) var terminal_velocity := 300.0
export (float) var gravity := 640.0
export (float) var jump_cancel_time := 0.5
var jump_cancel_timer = 0.0


func handle_input(event):
	if InputManager.input_enabled and event.is_action_pressed("dash"):
		emit_signal("finished", "dash")


func process_jump_gravity(delta):
	owner.velocity.y = min(owner.velocity.y + gravity * delta, terminal_velocity)
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)


func process_jump_cancel_timer(delta):
	if jump_cancel_timer > 0:
		if not Input.is_action_pressed('jump'):
			owner.velocity.y = 0
			jump_cancel_timer = 0
		else:
			jump_cancel_timer -= delta


func update(delta):
	face_axis(get_input_direction())
	owner.velocity.x = get_updated_h_velocity(owner.velocity.x)
	process_jump_gravity(delta)
	if owner.is_on_floor():
		emit_signal("finished", "idle")
	elif owner.is_on_wall():
		emit_signal("finished", "walled")
