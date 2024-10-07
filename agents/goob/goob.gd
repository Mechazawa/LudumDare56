class_name Goob extends Node2D

signal death

@onready var health: Health = $Health
@export var behavior: BehaviorTree = preload("res://scenes/levels/1/goob.tres")

var bullet_scene = preload("res://agents/bullet/bullet.tscn")
var wave_scene = preload("res://agents/gravity_wave/gravity_wave.tscn")
var homing_missile_scene = preload("res://agents/homing_missile/homing_missile.tscn")

var target: Node2D = null
#@onready var player: Node2D = get_tree().get_first_node_in_group(&"player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.damaged.connect(_on_health_damaged)
	health.death.connect(_on_health_death)
	#$GoobSprite.play(&"default")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_debug"):
		print_debug("fire!")
		target = get_tree().get_first_node_in_group(&"player")
		fire_homing_small()

func fire_wave(size: int, angle_deg_offset: float = 0.0) -> void:
	if target == null:
		return
	var wave = wave_scene.instantiate()
	wave.wave_size = size
	wave.position = $MouthMarker.position + Vector2(-5, -5)
	wave.rotation = (target.global_position - $MouthMarker.global_position).angle() + deg_to_rad(angle_deg_offset)
	add_child(wave)
	
func fire_bullet(size: int, angle_deg_offset: float = 0.0) -> void:
	if target == null:
		return
	var bullet = bullet_scene.instantiate()
	bullet.wave_size = size
	bullet.position = $MouthMarker.position + Vector2(-5, -5)
	bullet.rotation = (target.global_position - $MouthMarker.global_position).angle() + deg_to_rad(angle_deg_offset)
	add_child(bullet)
	
func fire_homing_small(angle_deg_offset: float = 0.0) -> void:
	if target == null:
		return
	var homing = homing_missile_scene.instantiate() as HomingMissile
	homing.position = $MouthMarker.position + Vector2(-5, -5)
	homing.target = target
	homing.texture = load("res://assets/attack-homing-2.png")
	homing.damage = 2
	homing.rotation = (target.global_position - $MouthMarker.global_position).angle() + deg_to_rad(angle_deg_offset)
	add_child(homing)
	
func fire_homing_large(angle_deg_offset: float = 0.0) -> void:
	if target == null:
		return
	var homing = homing_missile_scene.instantiate()
	homing.position = $MouthMarker.position + Vector2(-5, -5)
	homing.target = target
	homing.texture = load("res://assets/attack-homing-1.png")
	homing.damage = 3
	homing.rotation = (target.global_position - $MouthMarker.global_position).angle() + deg_to_rad(angle_deg_offset)
	add_child(homing)

func _on_health_death() -> void:
	#hackyhack
	for node in owner.get_children():
		if node is BTPlayer:
			node.active = false
	
	$DeathSound.play()
	$GibParticlesSmall.emitting = true
	$GibParticlesBig.emitting = true
	$GoobSprite.visible = false
	await $DeathSound.finished
	death.emit()
	await $GibParticlesSmall.finished
	queue_free()

func _on_health_damaged(target: Node, amount: float) -> void:
	if target.is_ancestor_of(self) or target == self:
		$GoobSprite/DamageIndicator.hit()
		$HurtSound.play()

func is_awake() -> bool:
	return health.max_health > health.get_current()

func collide() -> void:
	if health != null:
		health.take_damage(self, 0.5) 
