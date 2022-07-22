extends Control
tool

export var audio_type := 'master'
export var label_text := 'volume' setget set_label_text
export var steps := 10 setget set_steps
onready var slider: Slider = $HSlider
onready var label: Label = $Label


func _ready():
	label.text = label_text
	if Engine.editor_hint:
		return
	slider.value = AudioManager.get_volume(audio_type)
	slider.connect("value_changed", AudioManager, "set_volume", [audio_type, true])


func set_steps(new_steps: int):
	steps = new_steps
	slider.step = 1.0 / float(steps)


func set_label_text(new_label_text: String):
	label_text = new_label_text
	if label:
		label.text = label_text
