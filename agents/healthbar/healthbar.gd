@tool
extends Node2D

@onready var base_width = ($Full.region_rect as Rect2).size.x
@export var bar_empty: Texture2D
@export var bar_full: Texture2D
@export var bar_offset: int = 9

func _ready() -> void:
	$Empty.texture = bar_empty
	$Full.texture = bar_full
	$Full.region_rect.size.x = bar_full.get_width() - 9

func set_percentage(percentage: float) -> void:
	$Full.region_rect.size.x = base_width * percentage
