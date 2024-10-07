extends Node

var newspaper_index: int = 0
var transitioning: int = 0

@export var next_scene: PackedScene
@export var rotation_count: int = 2
@export var rotation_variation: float = 20
@onready var newspapers: Array[Node] = $NewsPapers.get_children()

func _ready() -> void:
	await _show_newspaper(newspapers[newspaper_index])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_tool") or Input.is_action_just_pressed("move_right"):
		if newspaper_index >= len(newspapers) - 1:
			_load_next_scene()
			return
		_change_newspaper(1)
	if Input.is_action_just_pressed("move_left") and newspaper_index > 0:
		_change_newspaper(-1)
	if Input.is_action_just_pressed("pause"):
		_load_next_scene()

func _change_newspaper(dir: int) -> void:
	if transitioning > 0:
		return
	_hide_newspaper(newspapers[newspaper_index])
	newspaper_index += dir
	_show_newspaper(newspapers[newspaper_index])

func _hide_newspaper(newspaper: Node2D) -> void:
	if newspaper is not Node2D:
		return
	transitioning += 1
	await Anima.Node(newspaper).anima_animation_frames({
		"from": {
			"position:y": $NewspaperMarker.position.y,
			"rotation_degrees": newspaper.rotation_degrees
		},
		"to": {
			"position:y": $WindowReference.get_viewport_rect().size.y + max(newspaper.get_viewport_rect().size.y, newspaper.get_viewport_rect().size.x),
			"rotation_degrees": newspaper.rotation_degrees + (randf()*720 - 360)
		},
		"easing": AnimaEasing.EASING.EASE_IN,
	}, 1.0).play().animation_completed
	transitioning -= 1

func _show_newspaper(newspaper: Node) -> void:
	if newspaper is not Node2D:
		return
	newspaper.visible = true
	transitioning += 1
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
	}, 2.0).play().animation_completed
	transitioning -= 1
	
func _load_next_scene() -> void:
	_hide_newspaper(newspapers[newspaper_index])
	SceneManager.change_scene(next_scene.resource_path)
