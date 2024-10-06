extends StaticBody2D

@onready var health: Health = get_tree().get_first_node_in_group("patient_health")
@onready var random_effect: RandomEffect = $RandomEffect

@export_category("Damage")
var collide_damage: float = 1

func _ready() -> void:
	if health != null:
		health.damaged.connect(_on_health_damaged)
		health.death.connect(_on_health_death)
	$AnimatedSprite2D.play(&"default")

func _process(delta: float) -> void:
	pass

func _on_health_death() -> void:
	$AnimatedSprite2D.visible = false
	$GibParticles.emitting = true
	await $GibParticles.finished
	queue_free() 

func _on_health_damaged(target: Node, amount: float) -> void:
	if target.is_ancestor_of(self) or target == self:
		$AnimatedSprite2D/DamageIndicator.hit()
		random_effect.play_random()

func collide() -> void:
	if health != null:
		health.take_damage(self, collide_damage) 

func _on_collision_polygon_2d_property_list_changed() -> void:
	_ready()
