extends KinematicBody2D

onready var dialogue_bubble: DialogueBubble = $DialogueBubble
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var interactable: Interactable = $Interactable
var dialogue_open := false


func _ready():
	dialogue_bubble.connect("dialogue_finished", self, "close_dialogue")
	animated_sprite.play()
	interactable.connect("interacted", self, "interact")


func interact():
	open_dialogue()


func open_dialogue():
	InputManager.disable_input()
	interactable.hide_prompt()
	dialogue_open = true
	dialogue_bubble.start_dialogue(
		[
			"che, [color=yellow]lamponne[/color]...",
			"te agachas y te la [color=yellow]ponen[/color]!",
			"jajajajaj     \njaj",
			"alto bobo"
		]
	)


func close_dialogue():
	InputManager.enable_input()
	interactable.show_prompt()
	dialogue_open = false
	dialogue_bubble.stop_dialogue()
