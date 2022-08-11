class_name SettingsResource
extends Resource

export var version := 1
export var custom_keybindings: Dictionary = {
	'jump': InputMap.get_action_list('jump'),
	'dash': InputMap.get_action_list('dash'),
	'interact': InputMap.get_action_list('interact')
}
export var volumes := {
	"Master": 1.0,
	"Music": 1.0,
	"SoundEffects": 1.0,
}
export var fullscreen := false
export var resolution := Vector2(1280, 720)

const SAVE_SETTINGS_BASE_PATH := "user://settings"


func write() -> void:
	ResourceSaver.save(get_file_path(), self)


static func exists() -> bool:
	return ResourceLoader.exists(get_file_path())

static func load() -> Resource:
	var settings_path := get_file_path()
	if ResourceLoader.has_cached(settings_path):
		# Once the resource caching bug is fixed, you will only need this line of code to load the settings game.
		return ResourceLoader.load(settings_path, "", true)

	# /!\ Workaround for bug https://github.com/godotengine/godot/issues/59686
	# Without that, sub-resources will not reload from the saved data.
	# We copy the SaveGame resource's data to a temporary file, load that file
	# as a resource, and make it take over the settings game.

	# We first load the settings game resource's content as text and store it.
	var file := File.new()
	if file.open(settings_path, File.READ) != OK:
		printerr("Couldn't read file " + settings_path)
		return null

	var data := file.get_as_text()
	file.close()

	# Then, we generate a random file path that's not in Godot's cache.
	var tmp_file_path := make_random_path()
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = make_random_path()

	# We write a copy of the settings game to that temporary file path.
	if file.open(tmp_file_path, File.WRITE) != OK:
		printerr("Couldn't write file " + tmp_file_path)
		return null

	file.store_string(data)
	file.close()

	# We load the temporary file as a resource.
	var settings = ResourceLoader.load(tmp_file_path, "", true)
	# And make it take over the settings path for the next time the player
	# saves.
	settings.take_over_path(settings_path)

	# We delete the temporary file.
	var directory := Directory.new()
	directory.remove(tmp_file_path)
	return settings

static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"

static func get_file_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_SETTINGS_BASE_PATH + extension
