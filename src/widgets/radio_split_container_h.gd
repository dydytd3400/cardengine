@tool
class_name HRadioSplitContainer extends HSplitContainer


@export_range(0, 1) var offset_radio: float = 0:
	set(value):
		offset_radio = value
		_update_split_offset()
	get:
		return offset_radio


func _update_split_offset():
	split_offset = size.x * offset_radio

func _ready() -> void:
	resized.connect(_update_split_offset)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update_split_offset()
