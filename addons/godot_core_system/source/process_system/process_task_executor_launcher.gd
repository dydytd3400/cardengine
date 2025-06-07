## 创建并启动独立的子流程任务组
##
## 负责为某个[ProcessTask]创建若干组独立流程。
## @experimental: 该方法尚未完善。
class_name ProcessTaskExecutorLauncher
extends ProcessTaskExecutor

## 通过当前[ProcessTask]的上下文为独立的子[ProcessTask]创建新的上下文对象,该值代表了子[ProcessTask]上下文的key
var context_key: String
## 通过当前[ProcessTask]的上下文为独立的子[ProcessTask]创建新的上下文对象,该值代表了子[ProcessTask]上下文的key所对应的值
var context_value: Variant
## [member context_values]不为空时，会以该数组的每个元素为子[ProcessTask]的上下文创建新上下文对象。且每个元素则对应一个新的[ProcessTask]
var context_values: Array
## 是否为并发任务
## [member context_values]不为空时，决定了这一层及的子[ProcessTask]是否以并发的方式进行和完成
var concurrent:bool = false
## 为子[ProcessTask]创建的上下文为空时，是否继续流程
var empty_able:bool = false
## 流程任务配置字典
var process: Dictionary
var _task_count:int = 0
func _execute(task: ProcessTask, msg: Dictionary = {}) -> void:
	if !process || process.is_empty():
		lg.fatal("process is Empty!")
		return
	var is_array = context_values && !context_values.is_empty()
	var is_single = context_value != null
	if is_array && is_single:
		lg.fatal("Cannot assign both context_value and context_values (mutually exclusive)")
		return
	if is_array:
		if !context_key || context_key.is_empty():
			lg.fatal("context_key is Empty!")
			return
		if concurrent:
			_task_count = context_values.size()
			for value in context_values:
				var process_task: ProcessTask = ProcessTemplate.new().generate(process)
				var current_msg = msg.duplicate()
				current_msg[context_key] = value
				process_task.state_exited.connect(_finish_one.bind(task,msg))
				process_task.enter(current_msg)
		else:
			var last_task = ProcessTemplate.new().generate(process)
			var first_task = last_task
			for i in range(1, context_values.size()):
				var current_value = context_values[i]
				var current_task: ProcessTask = ProcessTemplate.new().generate(process)
				if i == context_values.size()-1:
					current_task.state_exited.connect(completed.bind(task,msg))
				last_task.state_exited.connect(_enter_current_task.bind(current_task, current_value, msg))
				last_task = current_task
			_enter_current_task(first_task,context_values[0],msg) # 第一个进入
	elif empty_able:
		var process_task: ProcessTask = ProcessTemplate.new().generate(process)
		var current_msg = msg.duplicate()
		if context_key && !context_key.is_empty():
			current_msg[context_key] = context_value
		process_task.enter(current_msg)
		process_task.state_exited.connect(completed.bind(task,msg))
	else:
		completed(task,msg)


func _enter_current_task(current: ProcessTask, value: Variant, msg: Dictionary):
	var current_msg = msg.duplicate()
	current_msg[context_key] = value
	current.enter(current_msg)

func _finish_one(task: ProcessTask, msg: Dictionary):
	_task_count-=1
	if _task_count<=0:
		completed(task,msg)
