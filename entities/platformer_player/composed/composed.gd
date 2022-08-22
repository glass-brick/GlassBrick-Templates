extends KinematicBody2D

var facing_direction = Vector2.RIGHT
var velocity = Vector2.ZERO


func face_axis(axis: float):
	if axis > 0.0:
		face_direction(Vector2.RIGHT)
	elif axis < 0.0:
		face_direction(Vector2.LEFT)


func opposite(direction: Vector2):
	return Vector2.LEFT if direction.x > 0 else Vector2.RIGHT


func is_facing(direction: Vector2):
	return facing_direction == direction


func face_direction(direction: Vector2):
	var is_direction_valid = direction == Vector2.RIGHT or direction == Vector2.LEFT
	if is_direction_valid and not is_facing(direction):
		facing_direction = direction
		scale.x *= -1


func flip():
	face_direction(opposite(facing_direction))
