extends Node

@export var shake_amount: float = 2
@export var shake_duration: float = 0.5
@export var flash_color: Color = Color.WHITE
@export_range(0, 1) var flash_modifier: float = 0.6
@export var flash_duration: float = 0.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_flash_timer_timeout()

func hit() -> void:
	shake()
	flash()
	
func shake() -> void:
	Anima.Node(get_parent()).anima_animation_frames({
		["from", "to"]: {
			"translate:x": 0,
		},
		[10, 30, 50, 70, 90]: {
			"translate:x": -shake_amount,
		},
		[20, 40, 60, 80]: {
			"translate:x": shake_amount,
		},
	}, shake_duration).play()

func flash() -> void:
	$FlashTimer.stop()
	$FlashTimer.start(flash_duration)
	get_parent().material.set_shader_parameter("flash_modifier", flash_modifier)
	get_parent().material.set_shader_parameter("flash_color", flash_color)

func _on_flash_timer_timeout() -> void:
	get_parent().material.set_shader_parameter("flash_modifier", 0)
