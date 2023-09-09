extends OptionButton

@onready var screen_size = DisplayServer.screen_get_size()
@onready var base_resolution = Vector2(
	(
		ProjectSettings.get_setting('display/window/integer_resolution_handler/base_width')
		if ProjectSettings.has_setting('display/window/integer_resolution_handler/base_width')
		else 320
	),
	(
		ProjectSettings.get_setting('display/window/integer_resolution_handler/base_height')
		if ProjectSettings.has_setting('display/window/integer_resolution_handler/base_height')
		else 240
	)
)
@onready var resolution_options = []


func _ready():
	SettingsManager.connect('changed', Callable(self, '_on_settings_changed'))
	var option = base_resolution
	while option.x <= screen_size.x and option.y <= screen_size.y:
		resolution_options.append(option)
		option += base_resolution
	for idx in resolution_options.size():
		var resolution_option = resolution_options[idx]
		add_item('x%d' % (idx + 1), idx)
		if get_window().size == resolution_option:
			select(idx)
	connect('item_selected', Callable(self, '_on_resolution_selected'))


func _on_resolution_selected(idx):
	var selected_resolution = resolution_options[idx]
	get_window().size = selected_resolution
	get_window().position = (screen_size - selected_resolution) / 2
	SettingsManager.save_resolution(selected_resolution)


func _on_settings_changed():
	disabled = ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))
	for idx in resolution_options.size():
		if get_window().size == resolution_options[idx]:
			select(idx)
