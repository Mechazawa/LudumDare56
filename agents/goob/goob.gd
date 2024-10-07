extends Node2D

signal death

@onready var health: Health = $Health
@export var behavior: BehaviorTree = preload("res://scenes/levels/1/goob.tres")

var target: Node2D = null
#@onready var player: Node2D = get_tree().get_first_node_in_group(&"player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.damaged.connect(_on_health_damaged)
	health.death.connect(_on_health_death)
	#$GoobSprite.play(&"default")

func fire_wave(size: int, angle_deg_offset: float = 0.0, speed: float = 0.3) -> void:
	if target == null:
		return
	var wave = load(&"res://agents/gravity_wave/gravity_wave.tscn").instantiate()
	wave.wave_size = size
	wave.position = $MouthMarker.position + Vector2(-5, -5)
	wave.rotation = (target.global_position - $MouthMarker.global_position).angle() + deg_to_rad(angle_deg_offset)
	add_child(wave)
	await get_tree().create_timer(speed).timeout

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
