class_name StateMachine
extends Node

var state: int
var entity: Node
var time_since_states := {}


func _init(parent: Node, initial_state: int, states: Dictionary):
	entity = parent
	entity.add_child(self)
	state = initial_state
	for possible_state in states.values():
		time_since_states[possible_state] = 0.0


func _ready() -> void:
	if entity.has_method("transited_state"):
		entity.transited_state(null, state)


func _physics_process(delta: float) -> void:
	for possible_state in time_since_states.keys():
		if state == possible_state:
			time_since_states[possible_state] = 0.0
		time_since_states[possible_state] += delta


func travel_to(new_state: int) -> void:
	if state != new_state:
		state = new_state
		entity.transited_state(state, new_state)


func time_since(_state: int) -> float:
	return time_since_states[_state]
