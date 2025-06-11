extends Node

# 设计分辨率
var design_resolution := Vector2(1280, 720)

func _ready():
	# 设置初始窗口大小
	get_window().size = design_resolution

	## 设置拉伸模式
	#get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_EXPAND
	#get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP

	# 连接窗口大小改变信号
	get_window().size_changed.connect(_on_window_size_changed)

# 全屏切换函数
func toggle_fullscreen():
	if get_window().mode == Window.MODE_FULLSCREEN:
		get_window().mode = Window.MODE_WINDOWED
		get_window().size = design_resolution
	else:
		get_window().mode = Window.MODE_FULLSCREEN

# 窗口大小改变时的处理
func _on_window_size_changed():
	# 更新AspectRatioContainer的比例
	var aspect_node = $CanvasLayer/AspectRatioContainer
	var window_size
	if aspect_node:
		window_size = get_window().size
		aspect_node.ratio = window_size.x / window_size.y

	# 更新MarginContainer的边距（处理安全区域）
	var margin_node = $CanvasLayer/AspectRatioContainer/MarginContainer
	if margin_node:
		# 获取屏幕安全区域
		var safe_area = DisplayServer.get_display_safe_area()
		# 转换为相对于窗口的百分比
		var left_percent = safe_area.position.x / window_size.x
		var right_percent = (window_size.x - safe_area.end.x) / window_size.x
		var top_percent = safe_area.position.y / window_size.y
		var bottom_percent = (window_size.y - safe_area.end.y) / window_size.y

		margin_node.add_theme_constant_override("margin_left", left_percent * 100)
		margin_node.add_theme_constant_override("margin_right", right_percent * 100)
		margin_node.add_theme_constant_override("margin_top", top_percent * 100)
		margin_node.add_theme_constant_override("margin_bottom", bottom_percent * 100)
