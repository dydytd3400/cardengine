@tool
class_name AttributeNode
extends PercentContainer

var _initial_value = false
@export
var initial_value :int = 0:
	set(val):
		_initial_value = true
		initial_value=val
		_update_color()

@export
var value :int = 0:
	set(val):
		if !_initial_value:
			initial_value = val
		value=val
		_set_value(value)

@export_group("Icon Margins")
@export
var margin_bottom:int:
	set(val):
		margin_bottom=val
		_set_icon_margin_bottom(val)
@export
var margin_left:int:
	set(val):
		margin_left=val
		_set_icon_margin_left(val)
@export
var margin_right:int:
	set(val):
		margin_right=val
		_set_icon_margin_right(val)
@export
var margin_top:int:
	set(val):
		margin_top=val
		_set_icon_margin_top(val)
@export
var margin_value:int:
	set(val):
		margin_value=val
		margin_bottom=val
		margin_left=val
		margin_right=val
		margin_top=val

@export_group("Value Colors")
@export
var normal_color:Color = Color.ANTIQUE_WHITE:
	set(value):
		normal_color=value
		_update_color()
@export
var greater_color:Color = Color("#509a57"):
	set(value):
		greater_color=value
		_update_color()
@export
var less_color:Color  = Color("#47a1db"):
	set(value):
		less_color=value
		_update_color()

@export_group("")
@export
var icon:Texture2D:
	set(val):
		icon=val
		_set_icon(icon)


func add_to(val:int):
	# TODO 动画
	value += val

func reset(val:int):
	# TODO 动画
	value = val

func _set_icon_margin_bottom(margin:int):
	$MarginContainer.add_theme_constant_override("margin_bottom",margin)

func _set_icon_margin_left(margin:int):
	$MarginContainer.add_theme_constant_override("margin_left",margin)

func _set_icon_margin_right(margin:int):
	$MarginContainer.add_theme_constant_override("margin_right",margin)

func _set_icon_margin_top(margin:int):
	$MarginContainer.add_theme_constant_override("margin_top",margin)

func _set_value(val:int):
	_update_color()
	$Label.text=str(val)

func _set_icon(icon:Texture2D):
	$MarginContainer/icon.texture = icon

func _update_color():
	if value > initial_value:
		$Label.add_theme_color_override("font_color", greater_color)
	elif value < initial_value:
		$Label.add_theme_color_override("font_color", less_color)
	else :
		$Label.add_theme_color_override("font_color", normal_color)
