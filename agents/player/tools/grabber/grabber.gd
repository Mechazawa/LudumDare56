extends AnimatedSprite2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"action_tool"):
		_grab()
	if Input.is_action_just_released(&"action_tool"):
		_release()

func _grab() -> void:
	self.play(&"grab")
	for body in $Area2D.get_overlapping_bodies():
		$PinJoint2D.node_b = body.get_path()
		return

func _release() -> void:
	self.play_backwards(&"grab")
	$PinJoint2D.node_b = NodePath("")
