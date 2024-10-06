extends Node2D

@onready var health: Health = $Health
#@onready var player: Node2D = get_tree().get_first_node_in_group(&"player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.damaged.connect(_on_health_damaged)
	health.death.connect(_on_health_death)
	$AnimatedSprite2D.play(&"default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed(&"action_debug"):
		#fire_waves()

func fire_waves(target: Node2D, speed: float = 0.3) -> void:
	for i in range(3):
		var wave = load(&"res://agents/gravity_wave/gravity_wave.tscn").instantiate()
		wave.wave_size = 2 - i
		wave.position = $MouthMarker.position + Vector2(-5, -5)
		wave.rotation = (target.global_position - $MouthMarker.global_position).angle()
		add_child(wave)
		await get_tree().create_timer(speed).timeout

func _on_health_death() -> void:
	$DeathSound.play()
	$DeathSound.finished.connect(func(): queue_free())

func _on_health_damaged(target: Node, amount: float) -> void:
	if target.is_ancestor_of(self) or target == self:
		$AnimatedSprite2D/DamageIndicator.hit()
		$HurtSound.play()
