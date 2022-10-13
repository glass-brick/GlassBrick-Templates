extends "motion.gd"

export (float) var wall_slide_max_speed = 100.0
export (float) var gravity := 640.0


func enter():
	if owner.get_node("WallDetector").is_wall_behind():
		flip()
	owner.get_node("AnimatedSprite").play('WallSlide')


func update(delta):
	owner.velocity.y = clamp(
		owner.velocity.y + gravity * delta, -wall_slide_max_speed, wall_slide_max_speed
	)
	owner.move_and_slide(owner.velocity)
	var input_direction = get_input_direction()
	var is_moving_away = (
		input_direction != 0
		and sign(input_direction) != sign(owner.facing_direction.x)
	)
	if is_moving_away or not owner.get_node("WallDetector").is_wall_in_front():
		emit_signal("finished", "fall")
	elif owner.is_on_floor():
		emit_signal("finished", "idle")
	if InputManager.input_enabled:
		if Input.is_action_just_pressed("dash"):
			flip()
			emit_signal("finished", "dash")
		elif Input.is_action_just_pressed("jump"):
			flip()
			emit_signal("finished", "wall_jump")
