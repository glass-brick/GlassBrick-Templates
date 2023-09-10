extends Node2D

@export var animated_sprite_path : NodePath
@export var time_between_ghosts := 0.1
@export var ghost_color := Color.WHITE
var emitting_ghost_particles = false
var ghost_timer = 0
@onready var animated_sprite: AnimatedSprite2D = get_node(animated_sprite_path)
@onready var wall_slide_trail: CPUParticles2D = $WallSlideParticles
@onready var jump_particles: CPUParticles2D = $JumpParticles


func start_emitting_ghost_particles():
	emitting_ghost_particles = true
	ghost_timer = time_between_ghosts


func stop_emitting_ghost_particles(delay = 0.0):
	await get_tree().create_timer(delay).timeout
	emitting_ghost_particles = false


func draw_ghost():
	var ghost := Sprite2D.new()
	ghost.set_texture(
		animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation, animated_sprite.frame)
	)
	ghost.modulate = ghost_color
	ghost.global_position = global_position
	ghost.global_scale = global_scale
	ghost.global_rotation = global_rotation
	var tween := get_tree().create_tween()
	var final_color = ghost_color
	final_color.a = 0
	tween.tween_property(ghost, "modulate", final_color, 0.5)
	tween.connect('finished', Callable(self, 'on_ghost_faded').bind(tween))
	SceneManager._current_scene.add_child(ghost)


func on_ghost_faded(ghost, _key, tween):
	ghost.queue_free()
	tween.queue_free()


var instanced_particles = []


func emit_jump_particles():
	var particle = jump_particles.duplicate()
	add_child(particle)
	particle.emitting = true
	instanced_particles.append(particle)


func start_emitting_wall_slide_particles():
	wall_slide_trail.emitting = true


func stop_emitting_wall_slide_particles():
	wall_slide_trail.emitting = false


func _process(delta):
	process_ghost_timer(delta)
	process_instanced_particles()


func process_ghost_timer(delta):
	if emitting_ghost_particles:
		ghost_timer += delta
		if ghost_timer > time_between_ghosts:
			ghost_timer = 0
			draw_ghost()


func process_instanced_particles():
	var new_instanced_particles = []
	for particle in instanced_particles:
		if particle.emitting:
			new_instanced_particles.append(particle)
		else:
			particle.queue_free()
	instanced_particles = new_instanced_particles
