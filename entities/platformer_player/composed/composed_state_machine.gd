extends Node

signal state_changed(current_state)

export (NodePath) var initial_state
onready var states_map := {
	"idle": $Idle,
	"move": $Move,
	"jump": $Jump,
	"double_jump": $DoubleJump,
	"fall": $Fall,
	"walled": $Walled,
	"dash": $Dash,
	"wall_jump": $WallJump
}
var time_since_state := {}
var time_in_state := 0.0
var current_state = null
var current_state_key = null
var previous_state_key = null
var _active = false setget set_active


func _ready():
	for state_key in states_map.keys():
		var state = states_map[state_key]
		state.connect("finished", self, "_change_state")
		time_since_state[state_key] = INF
	initialize(initial_state)


func initialize(start_state):
	set_active(true)
	current_state = get_node(start_state)
	current_state.state_machine = self
	current_state.enter()


func set_active(value):
	_active = value
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		current_state = null
		time_in_state = 0.0
		for state_key in time_since_state.keys():
			time_since_state[state_key] = 0.0


func _input(event):
	current_state.handle_input(event)


func _physics_process(delta):
	for state_key in time_since_state.keys():
		if state_key != current_state_key:
			time_since_state[state_key] += delta
	time_in_state += delta
	current_state.update(delta)


func _change_state(state_name):
	if not _active or not state_name in states_map.keys():
		return
	current_state.exit()
	time_since_state[current_state_key] = 0.0
	time_in_state = 0.0
	previous_state_key = current_state_key
	current_state_key = state_name
	current_state = states_map[state_name]
	emit_signal("state_changed", current_state)
	current_state.enter()
