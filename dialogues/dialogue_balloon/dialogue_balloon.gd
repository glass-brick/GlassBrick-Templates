extends CanvasLayer

signal actioned(next_id)

const DialogueLine = preload("res://addons/dialogue_manager/dialogue_line.gd")

onready var balloon := $Balloon
onready var margin: MarginContainer = $Balloon/Margin
onready var character_label: RichTextLabel = $"%Character"
onready var dialogue_label: RichTextLabel = $"%Dialogue"
onready var responses_menu: Control = $"%ResponsesMenu"
onready var next_indicator: Control = $"%NextIndicator"

var dialogue: DialogueLine


func _ready() -> void:
	set_next_indicator_node()
	InputManager.connect("controls_changed", self, "set_next_indicator_node")
	dialogue_label.connect("finished", self, "_on_finish_writing")
	balloon.visible = false
	responses_menu.is_active = false
	next_indicator.visible = false

	if not dialogue:
		queue_free()
		return

	if dialogue.character != "":
		character_label.visible = true
		character_label.bbcode_text = dialogue.character
	else:
		character_label.visible = false
	dialogue_label.dialogue = dialogue

	yield(dialogue_label.reset_height(), "completed")

	# Show any responses we have
	responses_menu.setup_responses(dialogue.responses)

	# Make sure our responses get included in the height reset
	responses_menu.visible = true

	if dialogue.responses.size() > 0 or dialogue.time != null:
		# dont add next_indicator label when there are responses
		margin.set('custom_constants/margin_bottom', 10)
	else:
		# account for next_indicator label when there are no responses
		margin.set('custom_constants/margin_bottom', 20)
	margin.rect_size = Vector2(0, 0)

	yield(get_tree(), "idle_frame")

	balloon.rect_min_size = margin.rect_size
	balloon.rect_size = Vector2(0, 0)
	balloon.rect_global_position.y = balloon.get_viewport_rect().size.y - balloon.rect_size.y

	# Ok, we can hide it now. It will come back later if we have any responses
	responses_menu.visible = false

	# Show our box
	balloon.visible = true

	dialogue_label.type_out()


func _on_finish_writing():
	var next_id: String = ""
	if dialogue.responses.size() > 0:
		responses_menu.is_active = true
		responses_menu.visible = true
		responses_menu.index = 0
		var response = yield(responses_menu, "actioned")
		next_id = dialogue.responses[response[0]].next_id
	elif dialogue.time != null:
		var time = (
			dialogue.dialogue.length() * 0.02
			if dialogue.time == "auto"
			else dialogue.time.to_float()
		)
		yield(get_tree().create_timer(time), "timeout")
		next_id = dialogue.next_id
	else:
		next_indicator.visible = true
		while true:
			if Input.is_action_just_pressed("interact"):
				next_id = dialogue.next_id
				break
			yield(get_tree(), "idle_frame")

	# Send back input
	emit_signal("actioned", next_id)
	queue_free()


func set_next_indicator_node():
	for child in next_indicator.get_children():
		child.queue_free()
	next_indicator.add_child(InputManager.get_action_input_node("interact", 0))
