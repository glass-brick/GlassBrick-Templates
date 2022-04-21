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
