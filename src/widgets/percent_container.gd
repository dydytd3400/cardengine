
## 百分比适配容器
@tool
@icon("res://src/widgets/percent.svg") # e98f36
class_name PercentContainer
extends Control

@export_range(0, 1)
var width_percent: float = 1:
	set(value):
		width_percent = value
	get:
		return width_percent

@export_range(0, 1)
var height_percent: float = 1:
	set(value):
		height_percent = value
	get:
		return height_percent

@export_range(-1, 1)
var horizontal_margin: float = 0:
	set(value):
		horizontal_margin = value
	get:
		return horizontal_margin

@export_range(-1, 1)
var vertical_margin: float = 0:
	set(value):
		vertical_margin = value
	get:
		return vertical_margin

@export_enum("居左", "居中", "居右")
var horizontal: int = 0:
	set(value):
		horizontal = value
	get:
		return horizontal

@export_enum("居上", "居中", "居下")
var vertical: int = 0:
	set(value):
		vertical = value
	get:
		return vertical


func _update_size():
	if get_parent() is Control:
		var psize: Vector2  = (get_parent() as Control).size
		size.x = psize.x * width_percent
		size.y = psize.y * height_percent
		var margin_h: float = psize.x * horizontal_margin
		var margin_v: float = psize.y * vertical_margin
		var x: float          = margin_h
		var y: float          = margin_v
		if horizontal == 1:
			x += (psize.x - size.x) / 2.0
		elif horizontal == 2:
			x *= -1.0
			x += psize.x - size.x
		if vertical == 1.0:
			y += (psize.y - size.y) / 2.0
		elif vertical == 2:
			y *= -1.0
			y += psize.y - size.y
		position.x = x
		position.y = y

func _ready() -> void:
	if get_parent() is Control:
		_update_size()
		(get_parent() as Control).resized.connect(_update_size)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update_size()
