extends Node

var newspaper_index = 0
@export var next_scene: PackedScene
@export var rotation_count: int = 2
@export var rotation_variation: float = 20
@onready var newspapers: Array[Node2D] = [
	$Newspaper1,
	$Newspaper2,
	$Newspaper3,
	$Newspaper4,
	$Newspaper5,
]

func _ready() -> void:
	_show_newspaper(newspapers[newspaper_index])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_tool") or Input.is_action_just_pressed("move_right"):
		if newspaper_index >= len(newspapers) - 1:
			_load_next_scene()
			return
		await _hide_newspaper(newspapers[newspaper_index])
		newspaper_index += 1
		await _show_newspaper(newspapers[newspaper_index])
	if Input.is_action_just_pressed("move_left") and newspaper_index > 0:
		await _hide_newspaper(newspapers[newspaper_index])
		newspaper_index -= 1
		await _show_newspaper(newspapers[newspaper_index])
	if Input.is_action_just_pressed("pause"):
		_load_next_scene()

func _hide_newspaper(newspaper: Node2D) -> void:
	await Anima.Node(newspaper).anima_animation_frames({
		"from": {
			"position:y": $NewspaperMarker.position.y,
			"rotation_degrees": newspaper.rotation_degrees
		},
		"to": {
			"position:y": $WindowReference.get_viewport_rect().size.y + max(newspaper.get_viewport_rect().size.y, newspaper.get_viewport_rect().size.x),
			"rotation_degrees": randf()*360 - 180
		},
		"easing": AnimaEasing.EASING.EASE_IN,
	}, 1.0).play()
	#newspaper.visible = false

func _show_newspaper(newspaper: Node2D) -> void:
	#var target_rot = newspaper.rotation_degrees
	newspaper.visible = true
	await Anima.Node(newspaper).anima_animation_frames({
		"from": {
			"position:y": -newspaper.get_viewport_rect().size.y,
			"rotation_degrees": 0
		},
		"to": {
			"position:y": $NewspaperMarker.position.y,
			"rotation_degrees": rotation_count * 360 + (randf() * rotation_variation - rotation_variation / 2.0),
		},
		"easing": AnimaEasing.EASING.EASE_OUT,
	}, 2.0).play()
	
func _load_next_scene() -> void:
	SceneManager.change_scene(next_scene.resource_path)
