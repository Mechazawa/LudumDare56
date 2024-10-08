extends Sprite2D

@export var Bullet : PackedScene

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var pressed = Input.is_action_pressed(&"action_tool")
	if pressed and $Interval.is_stopped():
		$Interval.start()
		shoot()

func shoot() -> void:
	var bullet = Bullet.instantiate()
	#get_node(^"/").owner.add_child(bullet)
	get_tree().get_root().add_child(bullet) 
	bullet.transform = $Muzzle.global_transform
