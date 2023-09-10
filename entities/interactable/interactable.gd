@tool
extends Area2D
class_name Interactable
signal interacted

@export var prompt_container_path: NodePath:
	set(new_path):
		prompt_container_path = new_path
		if not is_inside_tree():
			await self.ready
		prompt_container = get_node(prompt_container_path)
@onready var prompt_container = get_node(prompt_container_path)
@export var collision_shape = RectangleShape2D.new():
	set(new_shape):
		collision_shape = new_shape
		collision_shape_node.shape = collision_shape
var collision_shape_node := CollisionShape2D.new()
var is_targeted = false
var enabled = true


func _ready():
	add_child(collision_shape_node)
	if Engine.is_editor_hint():
		return
	prompt_container.visible = false
	set_prompt()
	InputManager.connect("controls_changed", Callable(self, "set_prompt"))


func interact():
	if enabled:
		emit_signal("interacted")


func enable():
	enabled = true


func disable():
	enabled = false


func set_target():
	show_prompt()
	is_targeted = true


func unset_target():
	hide_prompt()
	is_targeted = false


func set_prompt():
	for child in prompt_container.get_children():
		child.queue_free()
	prompt_container.add_child(InputManager.get_action_input_node("interact", 0))


func show_prompt():
	prompt_container.visible = true
	var tween := get_tree().create_tween()
	tween.tween_property(prompt_container, "modulate", Color.WHITE, 0.2)


func hide_prompt():
	var tween := get_tree().create_tween()
	tween.tween_property(prompt_container, "modulate", Color.TRANSPARENT, 0.2)
	await tween.finished
	if not is_targeted:
		prompt_container.visible = false
