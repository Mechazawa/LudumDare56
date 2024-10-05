extends StaticBody2D

@onready var health: Health = $Health
@export_category("Damage")
var on_collide: float = 1
var shake_amount: float = 2
var shake_duration: float = 0.5

func _ready() -> void:
	health.damaged.connect(_on_health_damaged)
	health.death.connect(_on_health_death)

func _process(delta: float) -> void:
	pass

func _on_health_death() -> void:
	queue_free() # todo :shrug:

func _on_health_damaged(amount: float) -> void:
	Anima.Node($AnimatedSprite2D).anima_animation_frames({
		["from", "to"]: {
			"translate:x": 0
		},
		[10, 30, 50, 70, 90]: {
			"translate:x": -shake_amount,
		},
		[20, 40, 60, 80]: {
			"translate:x": shake_amount
		},
	}, shake_duration).play()

func collide() -> void:
	health.take_damage(1)
