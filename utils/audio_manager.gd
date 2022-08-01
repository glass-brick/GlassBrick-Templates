extends Node

# All this should be in an autoload since bgm/se should be accessible always
# Use setup_slider(slider, "bgm"/"se") to make a slider functional for volume change in settings
# Add the bus name to every bgm/se you use to make them react to the global volume

var audio_data = {
	"master":
	{
		"bus_name": "Master",
		"volume": 1.0,
	},
	"bgm":
	{
		"bus_name": "Music",
		"volume": 1.0,
	},
	"se":
	{
		"bus_name": "SoundEffects",
		"volume": 1.0,
	}
}


func _ready():
	pause_mode = PAUSE_MODE_PROCESS


func get_volume(type):
	return audio_data[type]["volume"]


func set_volume(local_value: float, audio_type: String, should_save: bool = true):
	audio_data[audio_type]["volume"] = local_value

	var real_volume = linear2db(local_value)
	var audio_index = AudioServer.get_bus_index(audio_data[audio_type]["bus_name"])

	if audio_index != -1:
		AudioServer.set_bus_volume_db(audio_index, real_volume)
		if is_zero_approx(local_value):
			AudioServer.set_bus_mute(audio_index, true)
		else:
			AudioServer.set_bus_mute(audio_index, false)
	if should_save:
		SettingsManager.save_audio(audio_type, local_value)
