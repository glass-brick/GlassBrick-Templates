extends Control
tool

export var bus_name := 'Master'
export var label_text := 'volume' setget set_label_text
export var steps := 10 setget set_steps
onready var slider: Slider = $HSlider
onready var label: Label = $Label


func _ready():
	label.text = label_text
	if Engine.editor_hint:
		return
	slider.value = Utils.get_volume(bus_name)
	slider.connect("value_changed", self, "set_volume")


func set_steps(new_steps: int):
	steps = new_steps
	slider.step = 1.0 / float(steps)


func set_label_text(new_label_text: String):
	label_text = new_label_text
	if label:
		label.text = label_text


func set_volume(volume: float):
	Utils.set_volume(bus_name, volume)
	SettingsManager.save_audio(bus_name, volume)
