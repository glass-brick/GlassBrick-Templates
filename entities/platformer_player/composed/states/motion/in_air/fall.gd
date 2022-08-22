extends "in_air.gd"


func enter():
	owner.get_node("AnimatedSprite").play('Fall')


func update(delta):
	if InputManager.input_enabled and Input.is_action_just_pressed('jump'):
		emit_signal("finished", "double_jump")
	.update(delta)
