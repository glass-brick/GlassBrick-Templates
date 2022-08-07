extends KinematicBody2D

export (String) var dialogue_node
export (Resource) var dialogue_resource
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var interactable: Interactable = $Interactable
var dialog: Node


func _ready():
	animated_sprite.play()
	interactable.connect("interacted", self, "interact")


func interact():
	InputManager.disable_input()
	interactable.hide_prompt()
	open_dialogue()


func open_dialogue(dialogue_line = dialogue_node):
	var dialogue = yield(
		DialogueManager.get_next_dialogue_line(dialogue_line, dialogue_resource), "completed"
	)
	if dialogue != null:
		var balloon = preload("res://dialogues/dialogue_balloon/dialogue_balloon.tscn").instance()
		balloon.dialogue = dialogue
		get_tree().current_scene.add_child(balloon)
		open_dialogue(yield(balloon, "actioned"))
	else:
		yield(get_tree().create_timer(0.2), "timeout")
		InputManager.enable_input()
		interactable.show_prompt()
