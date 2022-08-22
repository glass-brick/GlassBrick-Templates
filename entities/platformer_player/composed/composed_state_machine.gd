extends Node

signal state_changed(current_state)

export (NodePath) var initial_state
onready var states_map = {
	"idle": $Idle,
	"move": $Move,
	"jump": $Jump,
	"double_jump": $DoubleJump,
	"fall": $Fall,
	"walled": $Walled
}
var time_since_states := {}

var states_stack = []
var current_state = null
var _active = false setget set_active


func _ready():
	for state_key in states_map.keys():
		var state = states_map[state_key]
		state.connect("finished", self, "_change_state")
		time_since_states[state_key] = 0.0
	initialize(initial_state)


func initialize(start_state):
	set_active(true)
	states_stack.push_front(get_node(start_state))
	current_state = states_stack[0]
	current_state.enter()


func set_active(value):
	_active = value
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		states_stack = []
		current_state = null


func _input(event):
	current_state.handle_input(event)


func _physics_process(delta):
	current_state.update(delta)


func _change_state(state_name):
	if not _active or not state_name in states_map.keys():
		return
	current_state.exit()

	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]

	current_state = states_stack[0]
	emit_signal("state_changed", current_state)

	if state_name != "previous":
		current_state.enter()