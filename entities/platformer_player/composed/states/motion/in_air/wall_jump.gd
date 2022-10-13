extends "in_air.gd"

export (Vector2) var jump_speed := Vector2(300.0, 320.0)
export (float) var x_damping_speed := 800.0


func enter():
	owner.get_node("Jump").play()
	owner.get_node("AnimatedSprite").play('Jump')
	owner.get_node("PlayerParticles").emit_jump_particles()
	owner.velocity = jump_speed * Vector2(owner.facing_direction.x, -1)
	jump_cancel_timer = jump_cancel_time


func update(delta):
	process_jump_cancel_timer(delta)
	face_axis(get_input_direction())
	owner.velocity.x = move_toward(owner.velocity.x, 0, delta * x_damping_speed)
	process_jump_gravity(delta)
	if InputManager.input_enabled and Input.is_action_just_pressed('jump'):
		emit_signal("finished", "double_jump")
	if owner.velocity.y > 0:
		emit_signal("finished", "fall")
	if owner.is_on_floor():
		emit_signal("finished", "idle")
