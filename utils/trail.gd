extends Node2D

export (NodePath) var animated_sprite_path
export (float) var time_between_frames = 0.1
export (Color) var color = Color.white
export var enabled = false
var timer = 0
onready var animated_sprite: AnimatedSprite = get_node(animated_sprite_path)


func enable():
	enabled = true
	timer = time_between_frames


func disable(delay = 0.0):
	yield(get_tree().create_timer(delay), "timeout")
	enabled = false


func _process(delta):
	if enabled:
		timer += delta
		if timer > time_between_frames:
			timer = 0
			draw_ghost()


func draw_ghost():
	var ghost := Sprite.new()
	ghost.set_texture(
		animated_sprite.frames.get_frame(animated_sprite.animation, animated_sprite.frame)
	)
	ghost.global_position = global_position
	ghost.global_scale = global_scale
	ghost.global_rotation = global_rotation
	var tween := Tween.new()
	var final_color = color.blend(Color.transparent)
	final_color.a = 0
	tween.interpolate_property(ghost, "modulate", color, final_color, 0.5)
	tween.connect('tween_completed', self, 'on_ghost_faded', [tween])
	add_child(tween)
	tween.start()
	get_tree().current_scene.add_child(ghost)


func on_ghost_faded(ghost, _key, tween):
	ghost.queue_free()
	tween.queue_free()
