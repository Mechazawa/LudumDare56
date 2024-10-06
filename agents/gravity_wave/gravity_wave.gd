extends Node2D

enum WaveSize {SMALL, MEDIUM, LARGE}

@export var damage: float = 1
@export var wave_size: WaveSize = WaveSize.MEDIUM
@export var speed: float = 40
@export var linear_force: float = 60
@export var rotational_force_min: float = 10
@export var rotational_force_max: float = 20
@onready var active_wave: Area2D = {
	WaveSize.SMALL: $Small,
	WaveSize.MEDIUM: $Medium,
	WaveSize.LARGE: $Large,
}[wave_size]

func _ready() -> void:
	active_wave.visible = true
	active_wave.body_entered.connect(on_body_entered)
	$SpawnEffect.play()

func _physics_process(delta):
	position += transform.x * speed * delta
	#tmp
	var player = get_tree().get_first_node_in_group(&"player")
	#rotation = (player.global_position - self.global_position).angle()

func on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	body.find_child("Health").call_deferred("take_damage", damage)
	body.call_deferred("update_rotational_velocity", randf_range(rotational_force_min, rotational_force_max) * [-1, 1].pick_random())
	body.call_deferred("update_linear_velocity", (body.position - self.position).normalized() * 60)
	active_wave.visible = false
	active_wave.body_entered.disconnect(on_body_entered)
	$HitEffect.play()
	$HitEffect.finished.connect(func(): queue_free())

func _on_timeout_timer_timeout() -> void:
	queue_free()
