extends Node

# All this should be in an autoload since bgm/se should be accessible always
# Use setup_slider(slider, "bgm"/"se") to make a slider functional for volume change in settings
# Add the bus name to every bgm/se you use to make them react to the global volume

var audio_data = {
	"master":
	{
		"volume": 1.0,
	},
	"bgm":
	{
		"bus_name": "Music",
		"volume": 1.0,
		"max_volume": 0,
		"min_volume": -20,
	},
	"se":
	{
		"bus_name": "SoundEffects",
		"volume": 1.0,
		"max_volume": 0,
		"min_volume": -20,
	}
}

var slider_steps = 10


func get_volume(type):
	return audio_data[type]["volume"]


func set_master_volume(volume: float, save: bool = true):
	audio_data["master"]["volume"] = volume
	for audio_type in audio_data.keys():
		if audio_type != "master":
			set_volume(audio_data[audio_type]["volume"], audio_type, false)
	if save:
		SettingsManager.save_audio("master", volume)


func set_volume(local_value: float, audio_type: String, save: bool = true):
	if audio_type == "master":
		set_master_volume(local_value, save)
		return
	audio_data[audio_type]["volume"] = local_value

	var real_volume = (
		(
			local_value
			* audio_data["master"]["volume"]
			* (audio_data[audio_type]["max_volume"] - audio_data[audio_type]["min_volume"])
		)
		+ audio_data[audio_type]["min_volume"]
	)
	var audio_index = AudioServer.get_bus_index(audio_data[audio_type]["bus_name"])

	if audio_index != -1:
		AudioServer.set_bus_volume_db(audio_index, real_volume)
		if is_zero_approx(local_value * audio_data["master"]["volume"]):
			AudioServer.set_bus_mute(audio_index, true)
		else:
			AudioServer.set_bus_mute(audio_index, false)
	if save:
		SettingsManager.save_audio(audio_type, local_value)


func setup_volume_slider(slider: Slider, audio_type: String):
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.rounded = false
	slider.step = 1.0 / float(slider_steps)
	slider.value = audio_data[audio_type]["volume"]
	slider.connect("value_changed", self, "set_volume", [audio_type, true])
