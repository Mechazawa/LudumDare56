@tool
class_name NewsPaper extends Node2D

@export var title: String:
	get(): return _title
	set(value): 
		_title = value
		_propegate_exports()
@export var article: String:
	get(): return _article
	set(value): 
		_article = value
		_propegate_exports()
	

var _title: String
var _article: String

func _init() -> void:
	_propegate_exports()

func _propegate_exports() -> void:
	if $Title != null:
		$Title.text = _title
	if $Article != null:
		$Article.text = _article
