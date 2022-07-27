extends Panel
class_name DialogueBubble

signal dialogue_finished

# Amount of characters displayed in a second
export var text_speed = 5
var texts := []
var text_index := 0
var progress := 0.0
var finished_current := false
var started := false

onready var dialogue_content: RichTextLabel = $MarginContainer/RichTextLabel
onready var next_indicator: Control = $NextIndicator


func _ready():
	stop_dialogue()
	set_next_indicator_node()
	InputManager.connect("controls_changed", self, "set_next_indicator_node")


func start_dialogue(_texts: Array):
	texts = _texts
	visible = true
	var tween := Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 0.2)
	tween.start()
	yield(tween, "tween_completed")
	tween.queue_free()
	started = true
	set_text()


func stop_dialogue():
	next_indicator.visible = false
	started = false
	var tween := Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.2)
	tween.start()
	yield(tween, "tween_completed")
	tween.queue_free()
	visible = false
	texts = []
	text_index = 0
	progress = 0.0
	finished_current = false
	dialogue_content.text = ""


func set_text():
	dialogue_content.clear()
	dialogue_content.append_bbcode(texts[text_index])
	dialogue_content.percent_visible = 0.0
	progress = 0.0
	finished_current = false
	next_indicator.visible = false


func next_text():
	if text_index < texts.size() - 1:
		text_index += 1
		set_text()
	else:
		emit_signal("dialogue_finished")


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("interact") and started:
		get_tree().set_input_as_handled()
		if finished_current:
			next_text()
		else:
			progress = dialogue_content.text.length()


func _process(delta):
	if not started:
		return
	if not finished_current:
		if dialogue_content.percent_visible < 1:
			progress += delta * text_speed
			dialogue_content.visible_characters = int(progress)
		else:
			progress = 1
			finished_current = true
			next_indicator.visible = true


func set_next_indicator_node():
	for child in next_indicator.get_children():
		child.queue_free()
	next_indicator.add_child(InputManager.get_action_input_node("interact", 0))
