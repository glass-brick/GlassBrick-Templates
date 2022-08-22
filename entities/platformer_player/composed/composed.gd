extends KinematicBody2D

enum DIRECTIONS { LEFT, RIGHT }
var facing_direction = DIRECTIONS.RIGHT
var velocity = Vector2.ZERO


func face_axis(axis: float):
	if axis > 0.0:
		face_direction(DIRECTIONS.RIGHT)
	elif axis < 0.0:
		face_direction(DIRECTIONS.LEFT)


func opposite(direction):
	return DIRECTIONS.LEFT if direction == DIRECTIONS.RIGHT else DIRECTIONS.RIGHT


func is_facing(direction):
	return facing_direction == direction


func face_direction(direction):
	if direction in DIRECTIONS.values() and not is_facing(direction):
		facing_direction = direction
		scale.x *= -1
