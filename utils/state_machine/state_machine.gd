class_name StateMachine
extends Node

var state: String
var entity: Node
var states := []


func _init(parent, initial_state, all_states):
	entity = parent
	states = all_states
	entity.add_child(self)
	state = initial_state


func _ready() -> void:
	if entity.has_method("transited_state"):
		entity.transited_state(null, state)


func _process(delta: float) -> void:
	if entity.has_method("process_state"):
		entity.process_state(state, delta)


func _physics_process(delta: float) -> void:
	if entity.has_method("physics_process_state"):
		entity.physics_process_state(state, delta)


func travel_to(new_state):
	if state != new_state:
		state = new_state
		entity.transited_state(state, new_state)
