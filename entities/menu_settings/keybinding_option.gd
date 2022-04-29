extends Control

export (String) var action_name = ""

onready var action_label: Label = $Label
onready var instruction_label: Label = $HBoxContainer/PressAKey
onready var main_key: Button = $HBoxContainer/MainKey
onready var secondary_key: Button = $HBoxContainer/SecondaryKey
onready var timer: Timer = $Timer
var main_event: InputEvent
var secondary_event: InputEvent

var selected_key_idx = null


func _ready():
	InputManager.connect("control_mode_changed", self, "on_control_mode_changed")
	InputManager.connect("erased_action_event", self, "on_erased_action_event")
	action_label.text = action_name.capitalize()
	set_buttons()


func set_buttons():
	main_key.visible = true
	secondary_key.visible = true
	instruction_label.visible = false
	selected_key_idx = null

	main_event = InputManager.get_action_event(action_name, 0)
	var main_event_node := InputManager.get_input_event_node(main_event)
	for child in main_key.get_children():
		child.queue_free()
	main_key.add_child(main_event_node)

	secondary_event = InputManager.get_action_event(action_name, 1)
	var event_node := InputManager.get_input_event_node(secondary_event)
	for child in secondary_key.get_children():
		child.queue_free()
	secondary_key.add_child(event_node)


func _on_MainKey_pressed():
	start_key_change(0)


func _on_SecondaryKey_pressed():
	start_key_change(1)


func start_key_change(idx: int):
	instruction_label.visible = true
	main_key.visible = false
	secondary_key.visible = false
	selected_key_idx = idx
	timer.start()


func finish_key_change():
	set_buttons()
	if selected_key_idx == 1:
		main_key.grab_focus()
	else:
		secondary_key.grab_focus()
	selected_key_idx = null


func _process(_delta):
	if timer.time_left > 0:
		instruction_label.text = (
			"Press a %s (%d)"
			% [
				(
					"key"
					if InputManager.control_mode == InputManager.CONTROL_MODES.KEYBOARD
					else "button"
				),
				timer.time_left + 1
			]
		)


func on_control_mode_changed(_control_mode):
	set_buttons()


func on_erased_action_event(action, _event):
	if action == action_name:
		set_buttons()


func is_valid_change_event_input(event: InputEvent):
	if event is InputEventKey and event.is_pressed():
		return true
	elif event is InputEventMouseButton and event.is_pressed():
		return true
	elif event is InputEventJoypadButton and event.is_pressed():
		return true
	elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.5:
		event.axis_value = 1.0 if event.axis_value > 0 else -1.0
		return true
	elif event is InputEventMouseButton and event.is_pressed():
		return true
	return false


func _input(event: InputEvent):
	if selected_key_idx != null and is_valid_change_event_input(event):
		get_tree().set_input_as_handled()
		var event_to_change = main_event if selected_key_idx == 0 else secondary_event

		if event is InputEventKey and event.scancode == KEY_ESCAPE:
			InputMap.action_erase_event(action_name, event_to_change)
			finish_key_change()
			return

		InputManager.map_event_to_action(action_name, event, event_to_change)
		finish_key_change()


func _on_Timer_timeout():
	finish_key_change()
