extends Area2D

var interactables := []
var interactable_target: Interactable
var active = true


func _ready():
	connect('area_entered', self, '_on_area_entered')
	connect('area_exited', self, '_on_area_exited')


func _process(_delta):
	if active:
		check_interactables()


func _on_area_entered(area: Area2D):
	if area is Interactable:
		interactables.append(area)


func _on_area_exited(area: Area2D):
	if area is Interactable:
		if area == interactable_target:
			area.unset_target()
			interactable_target = null
		interactables.erase(area)


func check_interactables():
	var closest_distance := INF
	var closest_interactable: Interactable = null
	for interactable in interactables:
		var distance = (interactable.get_global_position() - get_global_position()).length()
		if interactable.enabled and distance < closest_distance:
			closest_distance = distance
			closest_interactable = interactable
	if closest_interactable != interactable_target:
		if interactable_target:
			interactable_target.unset_target()
		interactable_target = closest_interactable
		if interactable_target:
			interactable_target.set_target()
