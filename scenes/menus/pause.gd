extends Node

#don't look it's bad

var _paused: bool = false

func _ready() -> void:
	unpause()

func _process(delta: float) -> void:
	var pause_pressed = Input.is_action_just_pressed("pause")
	
	if not pause_pressed:
		return
	
	if _paused:
		unpause()
	else:
		pause()

func _on_retry_button_pressed() -> void:
	if _paused: 
		SceneManager.reload_scene()
		unpause()

func _on_continue_button_pressed() -> void:
	unpause()

func pause() -> void:
	_paused = true
	owner.get_tree().paused = true
	$Container.visible = true

func unpause() -> void:
	_paused = false
	owner.get_tree().paused = false
	$Container.visible = false
	
