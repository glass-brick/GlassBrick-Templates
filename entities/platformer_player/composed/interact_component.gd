extends Area2D
class_name InteractComponent

var interactable_target: Interactable


func check_interactables():
	var closest_distance := INF
	var closest_interactable: Interactable = null
	for area in get_overlapping_areas():
		if area is Interactable:
			var distance = (area.get_global_position() - get_parent().get_global_position()).length()
			if area.enabled and distance < closest_distance:
				closest_distance = distance
				closest_interactable = area
	if closest_interactable != interactable_target:
		if interactable_target:
			interactable_target.unset_target()
		interactable_target = closest_interactable
		if interactable_target:
			interactable_target.set_target()

	var interact_input = Input.is_action_just_pressed("interact")
	if interactable_target and interact_input and InputManager.input_enabled:
		interactable_target.interact()
