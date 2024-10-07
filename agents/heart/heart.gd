@tool
extends StaticBody2D

@onready var health: Health = get_tree().get_first_node_in_group("patient_health")
@onready var random_effect: RandomEffect = $RandomEffect

@export var has_pacemaker: bool = false:
	set(value):
		has_pacemaker = value
		_setup_heart()
@export var collide_damage: float = 1

func _ready() -> void:
	if health != null:
		health.damaged.connect(_on_health_damaged)
		health.death.connect(_on_health_death)
	$AnimatedSprite2D.play(&"default")
	_setup_heart()

func _safe_set(target: Node2D, field: String, value: bool) -> void:
	if target != null:
		target[field] = value

func _setup_heart() -> void:
	_safe_set($PacemakerColisionPolygon1, 'disabled', not has_pacemaker)
	_safe_set($PacemakerColisionPolygon2, 'disabled', not has_pacemaker)
	_safe_set($PacemakerColisionPolygon3, 'disabled', not has_pacemaker)
	_safe_set($CollisionPolygon2D, 'disabled', has_pacemaker)
	_safe_set($PacemakerSprite, 'visible', has_pacemaker)
	_safe_set($PacemakerTntSprite, 'visible', has_pacemaker)

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
