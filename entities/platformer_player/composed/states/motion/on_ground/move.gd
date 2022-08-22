extends "on_ground.gd"

export (int) var max_speed = 200
export (int) var acceleration_frames = 5
export (int) var decceleration_frames = 2
onready var acceleration = float(max_speed) / float(acceleration_frames)
onready var decceleration = float(max_speed) / float(decceleration_frames)


func enter():
	face_axis(get_input_direction())
	owner.get_node("AnimatedSprite").play("Run")


func update(delta):
	face_axis(get_input_direction())
	var input_direction = get_input_direction()
	if not is_zero_approx(input_direction):
		# important for controller stick owner.velocity management
		var input_max_speed = max_speed * abs(input_direction)
		owner.velocity.x = clamp(
			owner.velocity.x + acceleration * input_direction, -input_max_speed, input_max_speed
		)
	else:
		owner.velocity.x = move_toward(owner.velocity.x, 0, decceleration)

	owner.velocity.y = 10  # important for floor check
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	if is_zero_approx(owner.velocity.x):
		emit_signal("finished", "idle")
	.update(delta)
