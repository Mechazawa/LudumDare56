extends Node2D

@onready var health: Health = $Health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.damaged.connect(_on_health_damaged)
	health.death.connect(_on_health_death)
	$AnimatedSprite2D.play(&"default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_health_death() -> void:
	queue_free() # todo :shrug:

func _on_health_damaged(amount: float) -> void:
	$AnimatedSprite2D/DamageIndicator.hit()
