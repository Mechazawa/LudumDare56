extends StaticBody2D

@onready var health: Health = $Health
@onready var random_effect: RandomEffect = $RandomEffect

@export_category("Damage")
var collide_damage: float = 1

func _ready() -> void:
	health.damaged.connect(_on_health_damaged)
	health.death.connect(_on_health_death)
	$AnimatedSprite2D.play(&"default")

func _process(delta: float) -> void:
	pass

func _on_health_death() -> void:
	queue_free() # todo :shrug:

func _on_health_damaged(amount: float) -> void:
	$AnimatedSprite2D/DamageIndicator.hit()
	random_effect.play_random()

func collide() -> void:
	health.take_damage(collide_damage)
