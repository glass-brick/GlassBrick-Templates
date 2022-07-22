extends Node

const min_volume = -80.0
# when doing `log(0.00001) * logarithm_magic_number`, the result should approach -80.0 as much as possible
const logarithm_magic_number = 20.0 / log(10.0)

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

var slider_steps = 10


func _ready():
	pause_mode = PAUSE_MODE_PROCESS


func get_volume(type):
	return audio_data[type]["volume"]


func volume_to_logarithmic(amount: float):
	if is_zero_approx(amount):
		return min_volume
	return log(amount) * logarithm_magic_number


func set_volume(local_value: float, audio_type: String, should_save: bool = true):
	audio_data[audio_type]["volume"] = local_value

	var real_volume = volume_to_logarithmic(local_value)
	var audio_index = AudioServer.get_bus_index(audio_data[audio_type]["bus_name"])

	if audio_index != -1:
		AudioServer.set_bus_volume_db(audio_index, real_volume)
		if is_zero_approx(local_value):
			AudioServer.set_bus_mute(audio_index, true)
		else:
			AudioServer.set_bus_mute(audio_index, false)
	if should_save:
		SettingsManager.save_audio(audio_type, local_value)


func setup_volume_slider(slider: Slider, audio_type: String):
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.rounded = false
	slider.step = 1.0 / float(slider_steps)
	slider.value = audio_data[audio_type]["volume"]
	slider.connect("value_changed", self, "set_volume", [audio_type, true])
