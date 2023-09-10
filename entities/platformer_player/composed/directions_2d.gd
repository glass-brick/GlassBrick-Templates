class_name Directions2D
extends Node

enum DIRECTIONS { LEFT, RIGHT }
var facing_direction = DIRECTIONS.RIGHT


func get_axis(direction = facing_direction):
	return 1 if direction == DIRECTIONS.RIGHT else -1


func opposite(direction):
	return DIRECTIONS.LEFT if direction == DIRECTIONS.RIGHT else DIRECTIONS.RIGHT


func is_facing(direction):
	return facing_direction == direction


func flip():
	if is_facing(DIRECTIONS.LEFT):
		face_right()
	else:
		face_left()


func face_left():
	if is_facing(DIRECTIONS.RIGHT):
		facing_direction = DIRECTIONS.LEFT
		get_parent().scale.x = -1


func face_right():
	if is_facing(DIRECTIONS.LEFT):
		facing_direction = DIRECTIONS.RIGHT
		get_parent().scale.x = -1


func face_axis(axis: float):
	if axis > 0:
		face_right()
	if axis < 0:
		face_left()
