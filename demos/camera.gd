extends Camera2D

export (NodePath) var main_target
export (bool) var input_camera_controls_enabled = true
export (float) var input_camera_controls_amount = 50.0
export (bool) var lookahead = true
export (Vector2) var lookahead_amount = Vector2(0.25, 0.15)
var target: Node2D
var target_prev_position: Vector2
var target_velocity := Vector2.ZERO
var area: Rect2


func _ready():
	# fix camera jitter https://godotengine.org/qa/24510/camera2d-smoothing-jitter-in-godot-3-0
	Engine.set_target_fps(Engine.get_iterations_per_second())
	back_to_main_target()
	position = target_prev_position
	reset_smoothing()


func _process(delta):
	var target_position = target.get_position()
	position = target_position
	if input_camera_controls_enabled:
		var offset = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
		position += offset * input_camera_controls_amount
	if lookahead:
		var new_velocity = (target_position - target_prev_position) / delta
		var is_deccelerating = new_velocity.length() < target_velocity.length()
		target_velocity = lerp(target_velocity, new_velocity, 0.05 if is_deccelerating else 0.1)
		position += target_velocity * lookahead_amount
		target_prev_position = target_position


func set_target(new_target: Node2D):
	target = new_target
	target_prev_position = target.get_position()


func back_to_main_target():
	set_target(get_node(main_target))


func _input(event: InputEvent):
	# test target switching
	if event is InputEventKey and event.is_pressed() and event.scancode == KEY_Y:
		if target == get_node(main_target):
			set_target(get_node(@'../NPC'))
		else:
			back_to_main_target()
