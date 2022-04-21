extends Node

# All this should be in an autoload since bgm/se should be accessible always
# Use setup_slider(slider, "bgm"/"se") to make a slider functional for volume change in settings
# Add the bus name to every bgm/se you use to make them react to the global volume

var audio_data = {
	"bgm":
	{
		"bus_name": "Music",
		"volume": 0,
		"max_volume": 0,
		"min_volume": -20,
		"steps": 10,
	},
	"se":
	{
		"bus_name": "SoundEffects",
		"volume": 0,
		"max_volume": 0,
		"min_volume": -20,
		"steps": 10,
	},
}


func get_volume(type):
	return audio_data[type]["volume"]


func set_volume(value: float, audio_type: String):
	audio_data[audio_type]["volume"] = value
	var bus_name = audio_data[audio_type]["bus_name"]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), value)
	if value <= audio_data[audio_type]["min_volume"]:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), false)
	SettingsManager.save_audio(audio_type, value)


func setup_volume_slider(slider: Slider, audio_type: String):
	slider.min_value = audio_data[audio_type]["min_volume"]
	slider.max_value = audio_data[audio_type]["max_volume"]
	slider.step = (slider.max_value - slider.min_value) / audio_data[audio_type]["steps"]
	slider.value = audio_data[audio_type]["volume"]
	slider.connect("value_changed", self, "set_volume", [audio_type])
