extends Node

func _on_clipboard_player_ready() -> void:
	SceneManager.change_scene("res://scenes/levels/5/intro.tscn")
