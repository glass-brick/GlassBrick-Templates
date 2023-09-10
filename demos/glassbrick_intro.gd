extends CanvasLayer

@export var next_scene_path : String


func _ready():
	$AnimationPlayer.play('arrow clank clank')


func _process(_delta):
	if Input.is_action_just_pressed('ui_accept') and not SceneManager.is_transitioning:
		SceneManager.change_scene(next_scene_path)


func _on_AnimationPlayer_animation_finished(_animation_name):
	SceneManager.change_scene(next_scene_path)
