extends Control

onready var bgm_slider: Slider = $VBoxContainer/HSlider


func _ready():
	AudioManager.setup_volume_slider(bgm_slider, "bgm")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
