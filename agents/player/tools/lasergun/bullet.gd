extends Area2D

@export var speed = 75
@export var damage = 2

func _ready() -> void:
	$SpawnSound.play()

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	body.find_child("Health").call_deferred("take_damage", damage)
	queue_free()

func _on_timeout() -> void:
	queue_free()
