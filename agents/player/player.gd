extends CharacterBody2D

@onready var thruster: AnimatedSprite2D = $Thruster

@export_group("Movement")
@export_subgroup("Lateral")
@export var lateral_speed_forward: float = 70.0
@export var lateral_speed_backward: float = 30.0
@export var lateral_speed_min: float = 5.0
@export var lateral_friction: float = -30
@export_range(-1, 0) var lateral_drag: float = -0.06
@export_subgroup("Rotational")
@export var rotational_speed: float = 1.0
@export var rotational_speed_min: float = 0.1
@export var rotational_friction: float = -200
@export_range(-1, 0) var rotational_drag: float = -0.2

var lateral_acceleration: Vector2
var rotational_acceleration: float
var rotational_velocity: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thruster.play(&"default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lateral_acceleration = Vector2.ZERO
	rotational_acceleration = 0
	get_input()
	prevent_creep()
	apply_friction(delta)
	apply_movement(delta)
	move_and_slide()

func get_input() -> void:
	var rotation_move: float = Input.get_axis(&"move_left", &"move_right")
	var lateral_move: float = (
		Input.get_action_strength(&"move_up") * lateral_speed_forward
	) - (
		Input.get_action_strength(&"move_down") * lateral_speed_backward
	)
	
	thruster.visible = lateral_move > 0 
	
	rotational_acceleration = rotation_move * rotational_speed
	lateral_acceleration = Vector2(lateral_move, lateral_move).rotated(deg_to_rad(self.rotation_degrees - 45))
	
func prevent_creep() -> void:
	if lateral_acceleration.is_zero_approx() and abs(self.velocity.length()) < lateral_speed_min:
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
	lateral_acceleration += calc_friction_vec(delta, self.velocity, lateral_friction, lateral_drag)
	rotational_acceleration += calc_friction_deg(delta, rotational_velocity, rotational_friction, rotational_drag)
	
func apply_movement(delta: float) -> void:
	self.velocity += lateral_acceleration * delta
	rotational_velocity += rotational_acceleration * delta
	self.rotation_degrees += rotational_velocity
