extends KinematicBody2D
class_name Interactable

export (NodePath) var prompt_container_path
onready var prompt_container = get_node(prompt_container_path)
var is_targeted = false


func _ready():
	prompt_container.visible = false
	set_prompt()
	InputManager.connect("control_mode_changed", self, "set_prompt")


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("interact") and is_targeted:
		get_tree().set_input_as_handled()
		interact()


func interact():
	pass


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


func hide_prompt():
	prompt_container.visible = false