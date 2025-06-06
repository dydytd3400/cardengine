## 通过上下文简易调用目标方法的流程任务执行模块
class_name ProcessTaskExecutorCallContext
extends ProcessTaskExecutor

## 上下文中，要被调用的目标名
var target:String
## 要被调用目标的方法名
var method:String

func _execute(task: ProcessTask, msg: Dictionary = {}):
	if !target || target.is_empty():
		lg.fatal("Targer is Empty!")
		return
	if !method || method.is_empty():
		lg.fatal("Method is Empty!")
		return
	if !msg || msg.is_empty():
		lg.fatal("Context is Empty!")
		return
	if !msg.has(target) || !msg[target]:
		lg.fatal("Context Target: %s is Empty!" % target)
		return
	msg[target][method].call()
	completed(task, msg) # 默认流程任务执行者的逻辑是直接完成了当前任务，根据自身需求重载该方法
