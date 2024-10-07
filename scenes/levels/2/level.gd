extends Node

func _ready() -> void:
	for child in $Patient.get_children():
		if child is Rope:
			var dir = Vector2(randf() * 200.0 - 100.0, randf() * 200.0 - 100.0)
			var segment: RopeSegment = child.get_children().pick_random()
			segment.apply_central_impulse(dir)

func _on_player_death() -> void:
	await get_tree().create_timer(3.0).timeout	
	SceneManager.change_scene("res://scenes/levels/2/end_death.tscn")

func _on_patient_death() -> void:
	await get_tree().create_timer(1.0).timeout	
	$Gravestone.visible = true
	await Anima.Node($Gravestone).anima_animation(&"bouncing_in_up").play()
	await get_tree().create_timer(2.0).timeout	
	SceneManager.change_scene("res://scenes/levels/2/end_death.tscn")

func _on_goob_death() -> void:
	await get_tree().create_timer(3.0).timeout	
	SceneManager.change_scene("res://scenes/levels/2/end_saved.tscn")

func _process(delta: float) -> void:
	$HealthbarPatient.set_percentage(_safe_get_health_percentage($PatientHealth))
	$HealthbarPlayer.set_percentage(_safe_get_health_percentage($Player/Health))
	
func _safe_get_health_percentage(node: Node) -> float:
	if node == null:
		return 0.0
	return node.get_percentage()
