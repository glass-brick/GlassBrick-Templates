extends TileMap

var open := false
export (int) var height := 64
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


func _ready():
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
		self, "position", self.position, self.position + Vector2.UP * height, time, transition_type
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
		self.position + Vector2.DOWN * height,
		time,
		transition_type
	)
	tween.start()
	yield(tween, "tween_completed")
	open = false
	interactable.enable()
