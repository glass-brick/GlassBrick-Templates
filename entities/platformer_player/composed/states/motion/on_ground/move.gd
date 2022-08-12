extends "on_ground.gd"

export (int) var max_speed = 200
export (int) var acceleration_frames = 5
export (int) var decceleration_frames = 2
onready var acceleration = float(max_speed) / float(acceleration_frames)
onready var decceleration = float(max_speed) / float(decceleration_frames)


func enter():
	face_direction(get_input_facing_direction())
	owner.get_node("AnimatedSprite").play("Run")


func handle_input(event):
	return .handle_input(event)


func update(_delta):
	face_direction(get_input_facing_direction())
	if is_zero_approx(velocity.x):
		emit_signal("finished", "idle")

	var input_direction = get_input_direction()
	if not is_zero_approx(input_direction):
		# important for controller stick velocity management
		var input_max_speed = max_speed * abs(input_direction)
		velocity.x = clamp(
			velocity.x + acceleration * input_direction, -input_max_speed, input_max_speed
		)
	else:
		velocity.x = move_toward(velocity.x, 0, decceleration)

	velocity = owner.move_and_slide(velocity, Vector2.UP)
