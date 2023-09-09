@tool
extends Node2D

var open := false
@export (int) var height := 4: set = set_height
@export (float) var time := 1.0
var tween := Tween.new()
@onready var interactable: Interactable = $Interactable
const TransitionTypes := {
	'LINEAR': Tween.TRANS_LINEAR,
	'SINE': Tween.TRANS_SINE,
	'QUINT': Tween.TRANS_QUINT,
	'QUART': Tween.TRANS_QUART,
	'QUAD': Tween.TRANS_QUAD,
	'EXPO': Tween.TRANS_EXPO,
	'ELASTIC': Tween.TRANS_ELASTIC,
	'CUBIC': Tween.TRANS_CUBIC,
	'CIRC': Tween.TRANS_CIRC,
	'BOUNCE': Tween.TRANS_BOUNCE,
	'BACK': Tween.TRANS_BACK,
}
@export (TransitionTypes) var transition_type = TransitionTypes.CUBIC
@onready var tilemap: TileMap = $Tilemap


func _ready():
	if Engine.is_editor_hint():
		return
	interactable.connect("interacted", Callable(self, "interact"))
	add_child(tween)


func interact():
	if not tween.is_active():
		if open:
			close_door()
		else:
			open_door()


func open_door():
	interactable.disable()
	tween.interpolate_property(
		self,
		"position",
		self.position,
		self.position + Vector2.UP * height * tilemap.cell_size,
		time,
		transition_type
	)
	tween.start()
	await tween.tween_completed
	open = true
	interactable.enable()


func close_door():
	interactable.disable()
	tween.interpolate_property(
		self,
		"position",
		self.position,
		self.position + Vector2.DOWN * height * tilemap.cell_size,
		time,
		transition_type
	)
	tween.start()
	await tween.tween_completed
	open = false
	interactable.enable()


func set_height(new_height):
	height = new_height
	if not is_inside_tree():
		await self.ready
	tilemap.clear()
	for y in range(height):
		tilemap.set_cell(0, y, 0)
	tilemap.update_bitmask_region(Vector2.ZERO, Vector2(1, height))
	interactable.collision_shape.size = tilemap.cell_size * Vector2(0.5, height * 0.5)
	interactable.position = interactable.collision_shape.size
