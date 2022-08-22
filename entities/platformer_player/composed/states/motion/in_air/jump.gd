extends "in_air.gd"

export (float) var jump_speed := 320.0
export (float) var jump_cancel_time := 0.5
var jump_cancel_timer = 0.0


func enter():
	owner.velocity.y = -jump_speed
	owner.get_node("Jump").play()
	owner.get_node("AnimatedSprite").play('Jump')
	owner.get_node("PlayerParticles").emit_jump_particles()
	jump_cancel_timer = jump_cancel_time


func update(delta):
	if jump_cancel_timer > 0:
		if not Input.is_action_pressed('jump'):
			owner.velocity.y = 0
			jump_cancel_timer = 0
		else:
			jump_cancel_timer -= delta
	elif InputManager.input_enabled and Input.is_action_just_pressed('jump'):
		emit_signal("finished", "double_jump")
	if owner.velocity.y > 0:
		emit_signal("finished", "fall")
	.update(delta)
