extends Node2D
class_name Level
tool

var pause_menu = preload('res://entities/menus/pause_menu.tscn').instance()
var music_player = AudioStreamPlayer.new()
var background_layer: CanvasLayer = CanvasLayer.new()
var background_rect: TextureRect = TextureRect.new()
export (Texture) var background_texture setget set_background, get_background
export (AudioStream) var music setget set_music, get_music


func _enter_tree():
	background_layer.layer = -1
	background_rect.stretch_mode = TextureRect.STRETCH_TILE
	background_rect.anchor_bottom = 1.0
	background_rect.anchor_right = 1.0
	background_layer.add_child(background_rect)
	add_child(background_layer)
	music_player.pause_mode = PAUSE_MODE_PROCESS
	music_player.bus = "Music"
	music_player.autoplay = true
	add_child(music_player)
	add_child(pause_menu)


func set_background(new_texture: Texture):
	background_rect.texture = new_texture


func get_background():
	return background_rect.texture


func set_music(new_stream: AudioStream):
	music_player.stream = new_stream


func get_music():
	return music_player.stream
