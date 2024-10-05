extends Area2D

@export var speed = 75

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# todo signal body
	queue_free()

func _on_timeout() -> void:
	queue_free()
