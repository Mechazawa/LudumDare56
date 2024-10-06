@tool
extends Node2D

@export_range(2, 100) var size: int:
	set(value):
		size = value
		_init_segments()
@export var segment_start: Texture2D:
	set(value):
		segment_start = value
		_init_segments()
@export var segment_middle: Texture2D:
	set(value):
		segment_middle = value
		_init_segments()
@export var segment_end: Texture2D:
	set(value):
		segment_end = value
		_init_segments()
@export var anchor: Node2D:
	set(value):
		anchor = value
		_init_segments()
@export var collision: bool = true:
	set(value):
		collision = value
		_init_segments()

@onready var _last_segment: Node2D

func _ready() -> void:
	_init_segments()
	
func _init_segments() -> void:
	_clear_segments()
	_build_segments()
	
func _clear_segments() -> void:
	for child in get_children():
		if child is RopeSegment:
			child.queue_free()
	
func _build_segments() -> void:
	if segment_start == null:
		return
	if segment_middle == null and size > 2:
		return
	if segment_end == null:
		return
	if not is_inside_tree():
		return
	_last_segment = _append_segment(segment_start, anchor)
	for i in (size - 2):
		_last_segment = _append_segment(segment_middle, _last_segment)
	_last_segment = _append_segment(segment_end, _last_segment)

func _append_segment(texture: Texture2D, parent: Node2D = null) -> Node2D:
	var new_segment = preload("res://agents/rope/rope_segment.tscn").instantiate()
	new_segment.texture = texture
	if parent != null:
		new_segment.anchor = parent.get_path()
	new_segment.collision = collision
	if parent is RopeSegment:
		new_segment.position.x = parent.position.x
		new_segment.position.x += parent.texture.get_width()
	add_child(new_segment)
	return new_segment
