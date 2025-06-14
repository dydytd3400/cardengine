
## 百分比适配容器
@tool
@icon("res://src/widgets/percent_margin.svg") # e98f36
class_name PercentMarginContainer
extends MarginContainer


@export_range(-10,10)
var margin_bottom_percent:float:
	set(val):
		margin_bottom_percent=val
		_set_percent_margin_bottom(val)
@export_range(-10,10)
var margin_left_percent:float:
	set(val):
		margin_left_percent=val
		_set_percent_margin_left(val)
@export_range(-10,10)
var margin_right_percent:float:
	set(val):
		margin_right_percent=val
		_set_percent_margin_right(val)
@export_range(-10,10)
var margin_top_percent:float:
	set(val):
		margin_top_percent=val
		_set_percent_margin_top(val)


func _set_percent_margin_bottom(margin:float):
	add_theme_constant_override("margin_bottom",int(size.y*margin))

func _set_percent_margin_left(margin:float):
	add_theme_constant_override("margin_left",int(size.x*margin))

func _set_percent_margin_right(margin:float):
	add_theme_constant_override("margin_right",int(size.x*margin))

func _set_percent_margin_top(margin:float):
	add_theme_constant_override("margin_top",int(size.y*margin))
