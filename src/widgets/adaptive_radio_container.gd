
## 自适应宽高比容器

@tool
@icon("res://src/widgets/adaptive_radio.svg")
class_name AdaptiveRadioContainer extends Container


@export_range(0, 10)
## 宽高比
var radio: float = 0:
	set(value):
		radio = value
		_update_size()
	get:
		return radio

@export_enum("水平", "垂直")
## 适应方向
var orientation: int = 0:
	set(value):
		orientation = value
		_update_size()
	get:
		return orientation

@export
## 是否依据最小宽高进行适应
var is_custom_minimum: bool = false:
	set(value):
		is_custom_minimum = value
		_update_size()
	get:
		return is_custom_minimum

func _update_size():
	var value
	if orientation == 0:
		value = size.y * radio
		if is_custom_minimum:
			custom_minimum_size.x = value
			custom_minimum_size.y = 0
		size.x = value
	else:
		value = size.x / radio
		if is_custom_minimum:
			custom_minimum_size.x = 0
			custom_minimum_size.y = value
		size.y = value

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update_size()
