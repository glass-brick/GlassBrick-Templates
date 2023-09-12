extends Node
class_name CharacterStateMachine

@export var character : CharacterBody2D
@export var current_state : State
@export var debug := false

var states : Array[State]
var next_state : State
var prev_state : State
var debug_label : Label

func _ready():
	for child in get_children():
		if(child is State):
			child.character = character
			child.state_machine = self
			states.append(child)
		else:
			push_warning("Child %s is not a valid state" % child.name)
	if debug:
		var canvas_layer = CanvasLayer.new()
		debug_label = Label.new()
		debug_label.text = current_state.name
		canvas_layer.add_child(debug_label)
		add_child(canvas_layer)

func _physics_process(delta):
	for state in states:
		if state == current_state:
			state.time_since_active = 0.0
		else:
			state.time_since_active += delta
		
	current_state.state_process(delta)
	if debug:
		debug_label.text = current_state.name


func _input(event : InputEvent):
	current_state.state_input(event)

func travel_to(new_state: State) -> void:
	if current_state != new_state:
		call_deferred('deferred_travel_to')
		next_state = new_state


func deferred_travel_to():
	if next_state != null:
		current_state.on_exit()
		prev_state = current_state
		current_state = next_state
		next_state = null
		current_state.on_enter()

func time_since(state: State) -> float:
	return state.time_since_active
