@tool
extends Node2D

var open := false
@export var height := 4:
	set(new_height):
		height = new_height
		if not is_inside_tree():
			await self.ready
		tilemap.clear()
		for y in range(height):
			tilemap.set_cell(0, Vector2i(0, y))
		tilemap.update_bitmask_region(Vector2.ZERO, Vector2(1, height))
		interactable.collision_shape.size = tilemap.cell_size * Vector2(0.5, height * 0.5)
		interactable.position = interactable.collision_shape.size
@export var time := 1.0
@onready var tween := get_tree().create_tween()
@onready var interactable: Interactable = $Interactable
@onready var tilemap: TileMap = $Tilemap


func _ready():
	if Engine.is_editor_hint():
		return
	interactable.connect("interacted", Callable(self, "interact"))


func interact():
	if not tween.is_active():
		if open:
			close_door()
		else:
			open_door()


func open_door():
	interactable.disable()
	tween.tween_property(
		self,
		"position",
		self.position + Vector2.UP * height * tilemap.cell_size,
		time,
	)
	tween.start()
	await tween.finished
	open = true
	interactable.enable()


func close_door():
	interactable.disable()
	tween.tween_property(
		self,
		"position",
		self.position + Vector2.DOWN * height * tilemap.cell_size,
		time,
	)
	tween.start()
	await tween.tween_completed
	open = false
	interactable.enable()

