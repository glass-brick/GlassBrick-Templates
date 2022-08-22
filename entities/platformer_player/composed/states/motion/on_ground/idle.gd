extends "on_ground.gd"


func enter():
	owner.get_node("AnimatedSprite").play("Idle")


func update(_delta):
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", "move")
