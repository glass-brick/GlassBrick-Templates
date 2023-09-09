extends MenuOption

@export var bus_name := 'Master'
@export var label_text := 'volume': set = set_label_text
@export var steps := 10: set = set_steps
@onready var slider: Slider = $HSlider


func _ready():
	if Engine.is_editor_hint():
		return
	set_slider()
	slider.connect("value_changed", Callable(self, "set_volume"))
	SettingsManager.connect('changed', Callable(self, 'set_slider'))


func _input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and (event.button_index == MOUSE_BUTTON_WHEEL_DOWN || event.button_index == MOUSE_BUTTON_WHEEL_UP)
	):
		slider.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	else:
		slider.set_mouse_filter(Control.MOUSE_FILTER_PASS)


func set_steps(new_steps: int):
	steps = new_steps
	if not is_inside_tree():
		await self.ready
	slider.step = 1.0 / float(steps)


func set_label_text(new_label_text: String):
	label_text = new_label_text
	if not is_inside_tree():
		await self.ready
	label.text = label_text


func set_volume(volume: float):
	Utils.set_volume(bus_name, volume)
	SettingsManager.save_audio(bus_name, volume)


func set_slider():
	slider.value = Utils.get_volume(bus_name)
