extends StaticBody2D

@onready var health: Health = get_tree().get_first_node_in_group("patient_health")

func _ready() -> void:
	health.damaged.connect(_on_health_damaged)

func _process(delta: float) -> void:
	pass

func collide() -> void:
	if health != null:
		health.take_damage(self, 1)

func _on_health_damaged(target: Node, amount: float) -> void:
	if target.is_ancestor_of(self) or target == self:
		$BorderFlesh/DamageIndicator.hit()
		$RandomEffect.play_random()
