extends Node

func _get_base_path() -> String:
	return self.scene_file_path.rsplit("/", true, 1)[0]

func _ready():
	$Player.velocity = Vector2(20.0, 40.0)
	$Player.rotational_velocity = -2.0
	print_debug(_get_base_path())
	print_debug(_get_base_path() + "/asd")
	$PatientHealth._current = 15.0

func _on_player_death() -> void:
	await get_tree().create_timer(3.0).timeout	
	SceneManager.change_scene(_get_base_path() + "/end_death.tscn")

func _on_patient_death() -> void:
	await get_tree().create_timer(1.0).timeout	
	$Gravestone.visible = true
	await Anima.Node($Gravestone).anima_animation(&"bouncing_in_up").play()
	await get_tree().create_timer(2.0).timeout	
	SceneManager.change_scene(_get_base_path() + "/end_death.tscn")


func _on_goob_death() -> void:
	await get_tree().create_timer(3.0).timeout	
	SceneManager.change_scene(_get_base_path() + "/end_saved.tscn")

func _process(delta: float) -> void:
	$HealthbarPatient.set_percentage(_safe_get_health_percentage($PatientHealth))
	$HealthbarGoob.set_percentage(_safe_get_health_percentage($Node/Goob/Health))
	$HealthbarPlayer.set_percentage(_safe_get_health_percentage($Player/Health))
	
func _safe_get_health_percentage(node: Node) -> float:
	if node == null:
		return 0.0
	return node.get_percentage()
