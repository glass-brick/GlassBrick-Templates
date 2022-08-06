class_name Utils

static func merge_dicts(dict_one: Dictionary, dict_two: Dictionary):
	var final_dict := {}
	for key in dict_one:
		final_dict[key] = dict_one[key]
	for key in dict_two:
		if (
			final_dict.has(key)
			and typeof(final_dict[key]) == TYPE_DICTIONARY
			and typeof(dict_two[key]) == TYPE_DICTIONARY
		):
			final_dict[key] = merge_dicts(dict_one[key], dict_two[key])
		else:
			final_dict[key] = dict_two[key]
	return final_dict

static func find_focusable_child(node: Node, exclude_self: bool = true):
	if not exclude_self and node is Control and node.focus_mode == 2:
		return node
	for child in node.get_children():
		if child is Control and child.focus_mode == 2:
			return child
		else:
			var result = find_focusable_child(child, false)
			if result:
				return result
	return null

static func is_child_focused(node: Node, exclude_self: bool = true):
	if not exclude_self and node is Control and node.has_focus():
		return true
	for child in node.get_children():
		if child is Control and child.has_focus():
			return true
		elif is_child_focused(child, false):
			return true
	return false

static func set_volume(bus_name: String, volume: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear2db(volume))

static func get_volume(bus_name) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	return db2linear(AudioServer.get_bus_volume_db(bus_index))
