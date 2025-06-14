extends Node

signal step_completed(depth)

var current_depth = 0
const MAX_DEPTH = 2000  # 远超默认栈大小1024

func _ready():
	# 传统递归方式 (会栈溢出)
	#deep_recursion(0)

	# 信号分解方式
	start_safe_recursion()

var step=0
func deep_recursion(depth,max = MAX_DEPTH):
	if depth >= 100 * step:
		step+=1
		print("传统递归分步完成 深度:", get_stack_depth())
	if depth >= max:
		print("传统递归完成 深度:", get_stack_depth())
		return
	deep_recursion(get_stack_depth(),max)

func start_safe_recursion():
	current_depth = 0
	step_completed.connect(_on_step_completed)
	emit_signal("step_completed", current_depth,{"msg"=self})

func _on_step_completed(_depth,msg = {}):
	var depth = msg.msg.current_depth
	# 新的调用栈开始！
	#print("当前栈深度: ", get_stack_depth(),msg.msg)

	if depth >= MAX_DEPTH:
		print("信号分解完成! 总深度:", depth)
		return

	# 处理一部分深度 (例如每次100层)
	const CHUNK_SIZE = 100
	var target = min(depth + CHUNK_SIZE, MAX_DEPTH)

	# 模拟处理过程
	#for i in range(depth, target):
		#var x = i * i  # 模拟工作
	deep_recursion(depth,100)
	print("模拟工作后栈深度: ", get_stack_depth())
	# 安排下一步
	current_depth = target
	call_deferred("emit_signal", "step_completed", current_depth,{"msg"=self})

# 获取当前调用栈深度
func get_stack_depth():
	var stack = get_stack()
	return stack.size()

## 获取调用栈信息 (调试用)
#func get_stack():
	#var stack = []
	#var frame = get_tree().current_scene
	#while frame:
		#stack.append(frame.name if "name" in frame else str(frame))
		#frame = frame.get_parent()
	#return stack
