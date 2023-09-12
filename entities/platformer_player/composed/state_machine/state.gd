extends Node
class_name State

var character: CharacterBody2D
var state_machine: CharacterStateMachine
var time_since_active: float


func state_process(delta):
	pass


func state_input(event: InputEvent):
	pass


func on_enter():
	pass


func on_exit():
	pass
