extends Node

@export var next_scene: PackedScene

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_animation_player_animation_finished("none")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	SceneManager.change_scene(next_scene.resource_path)
