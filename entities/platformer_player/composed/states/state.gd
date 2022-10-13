# warning-ignore-all: UNUSED_SIGNAL
# warning-ignore-all: UNUSED_ARGUMENT
"""
Base interface for all states: it doesn't do anything in itself
but forces us to pass the right arguments to the methods below
and makes sure every State object had all of these methods.
"""
extends Node

signal finished(next_state_name)
var state_machine


# Initialize the state. E.g. change the animation
func enter() -> void:
	return


# Clean up the state. Reinitialize values like a timer
func exit() -> void:
	return


func handle_input(event: InputEvent) -> void:
	return


func update(delta: float) -> void:
	return
