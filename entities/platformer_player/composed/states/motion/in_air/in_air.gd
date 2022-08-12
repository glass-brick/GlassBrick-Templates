extends '../motion.gd'

export (int) var max_speed = 200
export (int) var acceleration_frames = 5
export (int) var decceleration_frames = 2
onready var acceleration = float(max_speed) / float(acceleration_frames)
onready var decceleration = float(max_speed) / float(decceleration_frames)

export (float) var gravity := 640.0


func update(delta):
	if owner.is_on_floor():
		emit_signal("finished", "idle")
	face_direction(get_input_facing_direction())
	velocity.y = velocity.y + gravity * delta
	velocity = owner.move_and_slide(velocity, Vector2.UP)

	var input_direction = get_input_direction()
	if not is_zero_approx(input_direction):
		# important for controller stick velocity management
		var input_max_speed = max_speed * abs(input_direction)
		velocity.x = clamp(
			velocity.x + acceleration * input_direction, -input_max_speed, input_max_speed
		)
	else:
		velocity.x = move_toward(velocity.x, 0, decceleration)
