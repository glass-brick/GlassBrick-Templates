class_name SettingsResource
extends Resource

const SAVE_SETTINGS_BASE_PATH := "user://settings"
const CURRENT_VERSION := 1.0
@export var version: float = CURRENT_VERSION
@export var custom_keybindings: Dictionary = {}
@export var volumes := {
	"Master": 0.5,
	"Music": 0.5,
	"SoundEffects": 0.5,
}
@export var fullscreen := false
@export var resolution := Vector2(1280, 720)

func write() -> void:
	ResourceSaver.save(self, SettingsResource.get_file_path())


static func exists() -> bool:
	return ResourceLoader.exists(get_file_path())

static func load() -> Resource:
	return ResourceLoader.load(SettingsResource.get_file_path(), "", ResourceLoader.CACHE_MODE_IGNORE)

static func get_file_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_SETTINGS_BASE_PATH + extension
