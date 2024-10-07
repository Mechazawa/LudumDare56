extends Node

func _on_clipboard_player_ready() -> void:
	SceneManager.change_scene(self.scene_file_path.rsplit("/", true, 1)[0] + "/level.tscn")
