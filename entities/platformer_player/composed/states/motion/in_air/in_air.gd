extends '../motion.gd'

export (int) var max_speed = 200
export (int) var acceleration_frames = 5
export (int) var decceleration_frames = 2
onready var acceleration = float(max_speed) / float(acceleration_frames)
onready var decceleration = float(max_speed) / float(decceleration_frames)
export (float) var terminal_velocity := 300.0
export (float) var gravity := 640.0


func update(delta):
	owner.face_axis(get_input_direction())

	var input_direction = get_input_direction()
	if not is_zero_approx(input_direction):
		# important for controller stick owner.velocity management
		var input_max_speed = max_speed * abs(input_direction)
		owner.velocity.x = clamp(
			owner.velocity.x + acceleration * input_direction, -input_max_speed, input_max_speed
		)
	else:
		owner.velocity.x = move_toward(owner.velocity.x, 0, decceleration)

	owner.velocity.y = min(owner.velocity.y + gravity * delta, terminal_velocity)
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	if owner.is_on_floor():
		emit_signal("finished", "idle")
