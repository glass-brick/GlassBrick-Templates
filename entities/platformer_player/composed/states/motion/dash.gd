extends "motion.gd"

export (float) var dash_speed = 500.0
export (float, 0, 0.5) var dash_duration = 0.2
var dash_timer = 0
var dash_jumped = false


func enter():
	dash_timer = 0
	var direction := Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	owner.get_node("PlayerParticles").start_emitting_ghost_particles()
	if is_zero_approx(direction.x) and is_zero_approx(direction.y):
		owner.velocity = owner.facing_direction * dash_speed
	else:
		if abs(direction.x) > 0.2:
			direction.x = 1 if direction.x > 0 else -1
		else:
			direction.x = 0
		if abs(direction.y) > 0.2:
			direction.y = 1 if direction.y > 0 else -1
		else:
			direction.y = 0
		owner.velocity = Vector2(direction.x, direction.y).normalized() * dash_speed
		face_axis(owner.velocity.x)


func exit():
	owner.get_node("PlayerParticles").stop_emitting_ghost_particles()
	owner.velocity.y = 0


func update(delta):
	owner.move_and_slide(owner.velocity)
	dash_timer += delta
	if dash_timer > dash_duration:
		emit_signal("finished", "fall")
	if is_zero_approx(owner.velocity.y) and owner.get_node("WallDetector").is_wall_in_front():
		emit_signal("finished", "walled")
