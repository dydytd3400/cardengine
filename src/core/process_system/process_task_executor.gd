## 流程任务执行模块
##
## 当[ProcessTask]启动后，随之执行[method ProcessTaskExecutor.execute][br]
## 当前执行模块自身或其外部持有者可通过调用[method ProcessTaskExecutor.complated]和[method ProcessTaskExecutor.cancel]来结束当前执行模块[br]
## 可通过[ProcessTemplate]自定义配置除[ProcessTaskBatch]以外的所有[ProcessTask]的[ProcessTaskExecutor][br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskExecutor
extends RefCounted

## 当前执行模块结束信号，[param complated]为[code]true[/code]时，则表示当前[ProcessTask]是通过[method ProcessTaskExecutor.complated]结束的，否则是通过[method ProcessTaskExecutor.cancel]结束的。
signal finished(complated: bool)


## 处理[param task]的具体逻辑,当[ProcessTask]启动时会通过[param msg]携带一些附加参数
func execute(task: ProcessTask, msg: Dictionary = {}):
	_execute(task, msg)

## 完成并结束当前执行模块
func complated(task: ProcessTask, msg: Dictionary = {}):
	_complated(task, msg)
	finished.emit(true, msg)

## 取消并结束当前执行模块
func cancel(task: ProcessTask, msg: Dictionary = {}):
	_cancel(task, msg)
	finished.emit(false, msg)


func _execute(task: ProcessTask, msg: Dictionary = {}):
	complated(task, msg) # 默认流程任务执行者的逻辑是直接完成了当前任务


func _complated(task: ProcessTask, msg: Dictionary = {}):
	pass


func _cancel(task: ProcessTask, msg: Dictionary = {}):
	pass
