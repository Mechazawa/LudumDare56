extends Node2D

@onready var base_width = ($Full.region_rect as Rect2).size.x

func set_percentage(percentage: float) -> void:
	$Full.region_rect.size.x = base_width * percentage
