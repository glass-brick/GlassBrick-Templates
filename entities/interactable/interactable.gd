tool
extends Area2D
class_name Interactable
signal interacted

export (NodePath) var prompt_container_path setget set_prompt_container_path
onready var prompt_container = get_node(prompt_container_path)
export (Shape2D) var collision_shape = RectangleShape2D.new() setget set_collision_shape
var collision_shape_node := CollisionShape2D.new()
var is_targeted = false


func _ready():
	add_child(collision_shape_node)
	if Engine.editor_hint:
		return
	prompt_container.visible = false
	set_prompt()
	InputManager.connect("controls_changed", self, "set_prompt")


func _unhandled_input(event: InputEvent):
	if (not Engine.editor_hint) and event.is_action_pressed("interact") and is_targeted:
		get_tree().set_input_as_handled()
		interact()


func interact():
	emit_signal("interacted")


func set_target():
	show_prompt()
	is_targeted = true


func unset_target():
	hide_prompt()
	is_targeted = false


func set_collision_shape(new_shape):
	collision_shape = new_shape
	collision_shape_node.shape = collision_shape


func set_prompt_container_path(new_path):
	prompt_container_path = new_path
	if Engine.editor_hint:
		return
	prompt_container = get_node(prompt_container_path)


func set_prompt():
	for child in prompt_container.get_children():
		child.queue_free()
	prompt_container.add_child(InputManager.get_action_input_node("interact", 0))


func show_prompt():
	prompt_container.visible = true
	var tween := Tween.new()
	add_child(tween)
	tween.interpolate_property(prompt_container, "modulate", Color.transparent, Color.white, 0.2)
	tween.start()
	yield(tween, "tween_completed")
	tween.queue_free()


func hide_prompt():
	var tween := Tween.new()
	add_child(tween)
	tween.interpolate_property(prompt_container, "modulate", Color.white, Color.transparent, 0.2)
	tween.start()
	yield(tween, "tween_completed")
	if not is_targeted:
		prompt_container.visible = false
	tween.queue_free()
