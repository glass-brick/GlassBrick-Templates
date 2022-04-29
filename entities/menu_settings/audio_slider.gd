extends Control
tool

export var audio_type = 'master'
export var label_text = 'volume'
onready var slider: Slider = $HSlider
onready var label: Label = $Label


func _ready():
	AudioManager.setup_volume_slider(slider, audio_type)


func _process(_delta):
	label.text = label_text
