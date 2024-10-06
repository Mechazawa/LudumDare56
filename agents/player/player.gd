extends CharacterBody2D

@onready var health: Health = $Health

signal death

@export_group("Ship")
@export var ship_tool: PackedScene = null
@export_group("Movement")
@export_subgroup("linear")
@export var linear_speed_forward: float = 70.0
@export var linear_speed_backward: float = 30.0
@export var linear_speed_min: float = 5.0
@export var linear_friction: float = -30
@export_range(-1, 0) var linear_drag: float = -0.06
@export_subgroup("Rotational")
@export var rotational_speed: float = 5.0
@export var rotational_speed_min: float = 0.1
@export var rotational_friction: float = -200
@export_range(-1, 0) var rotational_drag: float = -0.2
@export_subgroup("Physics")
@export var bounce_factor = 20

var linear_acceleration: Vector2
var rotational_acceleration: float
var rotational_velocity: float = 0
var ship_tool_instance: Node2D = null

func _ready() -> void:
	$Thruster.play(&"default")
	if ship_tool != null:
		ship_tool_instance = ship_tool.instantiate()
		add_child(ship_tool_instance)
		
func _physics_process(delta: float) -> void:
	if not health.is_alive():
		return
	linear_acceleration = Vector2.ZERO
	rotational_acceleration = 0
	handle_movement_input()
	prevent_creep()
	apply_friction(delta)
	apply_movement(delta)
	handle_collisions()
	move_and_slide()

func handle_collisions() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		self.velocity = collision.get_normal() * bounce_factor
		if $CollisionCooldown.is_stopped():
			collider.call_deferred('collide')
	
	if get_slide_collision_count() > 0:
		$CollisionCooldown.start()

func update_linear_velocity(_vel: Vector2) -> void:
	self.velocity = _vel

func update_rotational_velocity(_vel: float) -> void:
	self.rotational_velocity = _vel

func handle_movement_input() -> void:
	var rotation_move: float = Input.get_axis(&"move_left", &"move_right")
	var linear_move: float = (
		Input.get_action_strength(&"move_up") * linear_speed_forward
	) - (
		Input.get_action_strength(&"move_down") * linear_speed_backward
	)
	
	if linear_move > 0:
		$Thruster.visible = true
		$ThrusterSound.play()
	else:
		$Thruster.visible = false
		$ThrusterSound.stop()
	
	rotational_acceleration = rotation_move * rotational_speed
	linear_acceleration = Vector2(linear_move, linear_move).rotated(deg_to_rad(self.rotation_degrees - 45))
	
func prevent_creep() -> void:
	if linear_acceleration.is_zero_approx() and abs(self.velocity.length()) < linear_speed_min:
		self.velocity = Vector2.ZERO
	if rotational_acceleration == 0 and abs(rotational_velocity) < rotational_speed_min:
		rotational_velocity = 0

func calc_friction_vec(delta: float, velocity: Vector2, friction: float, drag: float) -> Vector2:
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	return drag_force + friction_force 

func calc_friction_deg(delta: float, velocity: float, friction: float, drag: float) -> float:
	var friction_force = velocity * friction * delta
	var drag_force = velocity * abs(velocity) * drag * delta
	return drag_force + friction_force
		
func apply_friction(delta: float) -> void:
	linear_acceleration += calc_friction_vec(delta, self.velocity, linear_friction, linear_drag)
	rotational_acceleration += calc_friction_deg(delta, rotational_velocity, rotational_friction, rotational_drag)
	
func apply_movement(delta: float) -> void:
	self.velocity += linear_acceleration * delta
	rotational_velocity += rotational_acceleration * delta
	self.rotation_degrees += rotational_velocity

func _on_health_damaged(target: Node, amount: float) -> void:
	$Sprite2D/DamageIndicator.flash()

func _on_health_death() -> void:
	self.velocity = Vector2.ZERO
	$Sprite2D.visible = false
	$Thruster.visible = false
	$ThrusterSound.stop()
	if ship_tool_instance != null:
		remove_child(ship_tool_instance)
		ship_tool_instance = null
	
	$ExplosionAnimation.visible = true
	$ExplosionAnimation.play(&"default")
	$ExplosionSound.play()
	$GibParticles.emitting = true
	await $ExplosionAnimation.animation_looped
	death.emit()
	$ExplosionAnimation.visible = false
	await $GibParticles.finished
	queue_free()
