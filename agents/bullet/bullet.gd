class_name Bullet extends Area2D

@export var speed = 75
@export var damage = 2
@export var texture: Texture2D = preload("res://assets/capsule-lasergun-laser.png")
@export var sound: AudioStream = preload("res://sound/laser.wav")

func _ready() -> void:
	$SpawnSound.stream = sound
	$SpawnSound.play()
	$SpawnSound.finished.connect(func(): $SpawnSound.queue_free())

func _physics_process(delta):
	position += transform.x * speed * delta 

func _on_body_entered(body: Node2D) -> void:
	if body ==  owner:
		return
	var health = body.find_child("Health");
	if health == null:
		health = body.get_tree().get_first_node_in_group("patient_health")
	
	health.call_deferred("take_damage", body, damage)
	body.call_deferred("bullet_hit")
	queue_free()

func _on_timeout() -> void:
	queue_free()
