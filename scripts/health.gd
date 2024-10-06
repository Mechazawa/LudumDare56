## Based on health script from LimboAI by Serhii Snitsaruk
## https://github.com/limbonaut/limboai/blob/master/demo/demo/agents/scripts/health.gd

@tool
class_name Health
extends Node

signal death
signal damaged(target: Node, amount: float)

@export var max_health: float = 10.0
@onready var _current: float = max_health

func take_damage(target: Node, amount: float) -> void:
	if _current <= 0.0:
		return

	_current -= amount
	_current = max(_current, 0.0)

	if _current <= 0.0:
		death.emit()
	else:
		damaged.emit(target, amount)

func get_current() -> float:
	return _current

func is_alive() -> bool:
	return _current > 0.0
