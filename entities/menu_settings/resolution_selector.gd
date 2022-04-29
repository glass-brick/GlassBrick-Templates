extends OptionButton

onready var screen_size = OS.get_screen_size()
onready var base_resolution = Vector2(
	ProjectSettings.get_setting('display/window/size/width'),
	ProjectSettings.get_setting('display/window/size/height')
)
onready var resolution_options = []


func _ready():
	var option = base_resolution
	while option.x <= screen_size.x and option.y <= screen_size.y:
		resolution_options.append(option)
		option += base_resolution
	for idx in resolution_options.size():
		var resolution_option = resolution_options[idx]
		add_item('%dx%d' % [resolution_option.x, resolution_option.y], idx)
		if OS.window_size == resolution_option:
			select(idx)
	connect('item_selected', self, '_on_resolution_selected')


func _process(_delta):
	disabled = OS.window_fullscreen
	for idx in resolution_options.size():
		if OS.window_size == resolution_options[idx]:
			select(idx)


func _on_resolution_selected(idx):
	var selected_resolution = resolution_options[idx]
	OS.window_size = selected_resolution
	OS.window_position = (screen_size - selected_resolution) / 2
