extends Node2D

export (NodePath) var collider_path
onready var collider: CollisionShape2D = get_node(collider_path)

var top_front_raycast = RayCast2D.new()
var bottom_front_raycast = RayCast2D.new()
var top_back_raycast = RayCast2D.new()
var bottom_back_raycast = RayCast2D.new()


func _ready():
	var height = collider.get_shape().get_extents().y
	var width = collider.get_shape().get_extents().x

	top_front_raycast.position = collider.position + Vector2(0, height)
	bottom_front_raycast.position = collider.position + Vector2(0, -height)
	top_back_raycast.position = collider.position + Vector2(0, height)
	bottom_back_raycast.position = collider.position + Vector2(0, -height)

	top_front_raycast.cast_to = Vector2(width + 1, 0)
	bottom_front_raycast.cast_to = Vector2(width + 1, 0)
	top_back_raycast.cast_to = Vector2(-(width + 1), 0)
	bottom_back_raycast.cast_to = Vector2(-(width + 1), 0)

	top_front_raycast.collision_mask = 2
	bottom_front_raycast.collision_mask = 2
	top_back_raycast.collision_mask = 2
	bottom_back_raycast.collision_mask = 2

	get_parent().call_deferred("add_child", top_front_raycast)
	get_parent().call_deferred("add_child", bottom_front_raycast)
	get_parent().call_deferred("add_child", top_back_raycast)
	get_parent().call_deferred("add_child", bottom_back_raycast)

	top_front_raycast.enabled = true
	bottom_front_raycast.enabled = true
	top_back_raycast.enabled = true
	bottom_back_raycast.enabled = true


func is_wall_in_front():
	return top_front_raycast.is_colliding() or bottom_front_raycast.is_colliding()


func is_wall_behind():
	return top_back_raycast.is_colliding() or bottom_back_raycast.is_colliding()


func is_on_wall():
	return is_wall_in_front() or is_wall_behind()
