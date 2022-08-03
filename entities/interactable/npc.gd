extends KinematicBody2D

export (String) var timeline_name
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var interactable: Interactable = $Interactable
var dialog: Node


func _ready():
	animated_sprite.play()
	interactable.connect("interacted", self, "interact")


func interact():
	open_dialogue()


func open_dialogue():
	InputManager.disable_input()
	interactable.hide_prompt()
	dialog = Dialogic.start(timeline_name)
	dialog.connect("timeline_end", self, "_on_close_dialogue")
	add_child(dialog)


func _on_close_dialogue(_timeline_name):
	InputManager.enable_input()
	interactable.show_prompt()
	if dialog.is_connected("timeline_end", self, "_on_close_dialogue"):
		dialog.disconnect("timeline_end", self, "_on_close_dialogue")
