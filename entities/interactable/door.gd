extends TileMap

var open := false
var height := 64
var time := 1.0
var tween := Tween.new()
onready var interactable: Interactable = $Interactable


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
	tween.interpolate_property(
		self, "position", self.position, self.position + Vector2.UP * height, time
	)
	tween.start()
	yield(tween, "tween_completed")
	open = true


func close_door():
	tween.interpolate_property(
		self, "position", self.position, self.position + Vector2.DOWN * height, time
	)
	tween.start()
	yield(tween, "tween_completed")
	open = false
