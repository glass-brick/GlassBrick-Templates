extends CharacterBody2D

@export var dialogue_node: String
@export var dialogue_resource: Resource
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable: Interactable = $Interactable
var dialog: Node


func _ready():
	animated_sprite.play()
	interactable.connect("interacted", Callable(self, "interact"))


func interact():
	InputManager.disable_input()
	interactable.hide_prompt()
	open_dialogue()


func open_dialogue(dialogue_line = dialogue_node):
	pass
	# var dialogue = yield(
	# 	DialogueManager.get_next_dialogue_line(dialogue_line, dialogue_resource), "completed"
	# )
	# if dialogue != null:
	# 	var balloon = preload("res://dialogues/dialogue_balloon/dialogue_balloon.tscn").instantiate()
	# 	balloon.dialogue = dialogue
	# 	get_tree().current_scene.add_child(balloon)
	# 	open_dialogue(await balloon.actioned)
	# else:
	# 	await get_tree().create_timer(0.2).timeout
	# 	InputManager.enable_input()
	# 	interactable.show_prompt()
