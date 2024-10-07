class_name HomingMissile extends Area2D

@export var steer_force = 50.0
@export var speed = 30.0
@export var damage = 3.0
@export var texture: Texture2D = preload("res://assets/attack-homing-1.png")
@export var target: Node2D = null

var texture_explosion_1 = preload("res://assets/capsule-explosion-1.png")
var texture_explosion_2 = preload("res://assets/capsule-explosion-2.png")

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO

var explode_sound = preload("res://sound/capsule-explosion.wav")
var spawn_sounds = [
	preload("res://sound/homing-missle-fire-01.wav"),
	preload("res://sound/homing-missle-fire-02.wav"),
	preload("res://sound/homing-missle-fire-03.wav"),
]

func _ready() -> void:
	$SpawnSound.stream = spawn_sounds.pick_random()
	$SpawnSound.play()
	$Sprite2D.texture = texture
	var collision_radius = min(texture.get_height(), texture.get_width()) / 2.0
	($CollisionShape2D.shape as CircleShape2D).radius = collision_radius
	#velocity = transform.x * speed

func _physics_process(delta: float) -> void:
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clampf(-speed, speed)
	rotation = velocity.angle()
	position += velocity * delta

func _process(delta: float) -> void:
	if not target or target.is_queued_for_deletion():
		explode()

func _on_body_entered(body: Node2D) -> void:
	if body is Goob:
		return
	
	var health = body.find_child("Health");
	if health == null:
		health = body.get_tree().get_first_node_in_group("patient_health")
	health.call_deferred("take_damage", body, damage)
	explode()

func _on_timeout() -> void:
	explode()
	
func explode() -> void:
	set_physics_process(false)
	# had time pressure, bad code
	$SpawnSound.stream = explode_sound
	$SpawnSound.play()
	$Sprite2D.texture = texture_explosion_1
	await get_tree().create_timer(0.1).timeout	
	$Sprite2D.texture = texture_explosion_2
	await get_tree().create_timer(0.2).timeout	
	$Sprite2D.visible = false
	await $SpawnSound.finished
	queue_free()
	
func bullet_hit() -> void:
	explode()

func seek() -> Vector2:
	var steer = Vector2.ZERO
	if target:
		var desired = (target.global_position - global_position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		area.queue_free()
		explode()
