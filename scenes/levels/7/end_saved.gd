extends Node

func _on_clipboard_player_ready() -> void:
	SceneManager.change_scene("res://scenes/levels/ending/newspapers.tscn")
