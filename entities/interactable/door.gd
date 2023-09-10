@tool
extends Node2D

var open := false

@onready var interactable: Interactable = $Interactable
@onready var tilemap: TileMap = $Tilemap

@export var time := 1.0
@export var height := 3:
	set(new_height):
		height = new_height
		if not is_inside_tree():
			await self.ready
		tilemap.clear()
		tilemap.set_cells_terrain_connect(0, range(height).map(func(y): return Vector2i(0, y)), 0, 0, false)
		interactable.collision_shape.size = Vector2(tilemap.tile_set.tile_size) * Vector2(1, height)
		interactable.position = Vector2(tilemap.tile_set.tile_size) * Vector2(1, height) / 2.0


func _ready():
	if Engine.is_editor_hint():
		return
	interactable.connect("interacted", Callable(self, "interact"))


func interact():
	if interactable.enabled:
		if open:
			close_door()
		else:
			open_door()


func open_door():
	interactable.disable()
	var tween = get_tree().create_tween()
	tween.tween_property(tilemap, "position",	Vector2.UP * height * 16,	time)
	await tween.finished
	open = true
	interactable.enable()


func close_door():
	interactable.disable()
	var tween = get_tree().create_tween()
	tween.tween_property(tilemap,	"position", Vector2.ZERO, time)
	await tween.finished
	open = false
	interactable.enable()

