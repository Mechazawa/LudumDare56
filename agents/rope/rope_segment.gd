@tool
class_name RopeSegment extends RigidBody2D

@export var collision: bool:
	get(): return _collision
	set(value):
		_collision = value
		if $CollisionShape2D != null:
			$CollisionShape2D.disabled = not value

@export var texture: Texture2D:
	get(): return _texture
	set(value):
		_texture = value
		if $Sprite2D != null:
			$Sprite2D.texture = value
			_update_shape()

@export var anchor: NodePath:
	get(): return _anchor
	set(value):
		_anchor = value
		if $PinJoint2D != null:
			$PinJoint2D.node_a = value

# Private backing fields to store values until nodes are ready
var _collision: bool = false
var _texture: Texture2D
var _anchor: NodePath

func _ready() -> void:
	collision = _collision
	texture = _texture
	anchor = _anchor
	_update_shape()

func _update_shape() -> void:
	var collision_shape = $CollisionShape2D.shape as CapsuleShape2D
	var width = texture.get_width()
	var height = texture.get_height()
	
	if height > width:
		$CollisionShape2D.rotation_degrees = 0
		$CollisionShape2D.position.x = height / 2.0
		$Sprite2D.position.x = height / 2.0
		collision_shape.radius = width / 2.0
		collision_shape.height = height
	else:
		$CollisionShape2D.rotation_degrees = 90
		$CollisionShape2D.position.x = width / 2.0
		$Sprite2D.position.x = width / 2.0
		collision_shape.radius = height / 2.0
		collision_shape.height = width
