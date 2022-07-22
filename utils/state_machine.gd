class_name StateMachine
extends Node

var state: int
var entity: Node
var time_since_states := {}
var time_in_state := 0.0
var next_state = null
var states := {}


func _init(parent: Node, initial_state: int, _states: Dictionary):
	entity = parent
	entity.add_child(self)
	state = initial_state
	states = _states
	for possible_state in states.values():
		time_since_states[possible_state] = 0.0


func _ready() -> void:
	if entity.has_method("transited_state"):
		entity.call_deferred('transited_state', null, state)


func _physics_process(delta: float) -> void:
	for possible_state in time_since_states.keys():
		if state == possible_state:
			time_since_states[possible_state] = 0.0
		time_since_states[possible_state] += delta
	time_in_state += delta


func travel_to(new_state: int) -> void:
	if state != new_state:
		call_deferred('deferred_travel_to')
		next_state = new_state


func deferred_travel_to():
	if next_state != null:
		if entity.has_method("transited_state"):
			entity.transited_state(state, next_state)
		state = next_state
		next_state = null
		time_in_state = 0.0


func time_since(_state: int) -> float:
	return time_since_states[_state]


func print_state(_state):
	for state_key in states.keys():
		if _state == states[state_key]:
			print("State: " + state_key)
			return
