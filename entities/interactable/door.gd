extends Node2D
tool

var open := false
export (int) var height := 4 setget set_height
export (float) var time := 1.0
var tween := Tween.new()
onready var interactable: Interactable = $Interactable
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
export (TransitionTypes) var transition_type = TransitionTypes.CUBIC
onready var tilemap: TileMap = $Tilemap


func _ready():
	if Engine.editor_hint:
		return
	interactable.connect("interacted", self, "interact")
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
	yield(tween, "tween_completed")
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
	yield(tween, "tween_completed")
	open = false
	interactable.enable()


func set_height(new_height):
	height = new_height
	$Tilemap.clear()
	for y in range(height):
		$Tilemap.set_cell(0, y, 0)
	$Tilemap.update_bitmask_region(Vector2.ZERO, Vector2(1, height))
	$Interactable.collision_shape.extents = $Tilemap.cell_size * Vector2(0.5, height * 0.5)
	$Interactable.position = $Interactable.collision_shape.extents
