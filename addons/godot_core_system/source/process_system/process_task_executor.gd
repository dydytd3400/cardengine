## 流程任务执行模块
##
## 当[ProcessTask]启动后，随之执行[method execute][br]
## 当前执行模块自身或其外部持有者可通过调用[method completed]和[method cancel]来结束当前执行模块[br]
## 可通过[ProcessTemplate]自定义配置除[ProcessTaskBatch]以外的所有[ProcessTask]的[ProcessTaskExecutor][br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskExecutor
extends ProcessTaskReader

## 当前执行模块结束信号，[param completed]为[code]true[/code]时，则表示当前[ProcessTask]是通过[method completed]结束的，否则是通过[method cancel]结束的。
signal finished(completed: bool)
signal execution(task: ProcessTask, msg: Dictionary)

## 处理[param task]的具体逻辑,当[ProcessTask]启动时会通过[param msg]携带一些附加参数
func execute(task: ProcessTask, msg: Dictionary = {}):
	write_to_member(msg)
	_execute(task, msg)
	execution.emit(task, msg)

## 完成并结束当前执行模块
func completed(task: ProcessTask, msg: Dictionary = {}):
	_completed(task, msg)
	finished.emit(true, msg)

## 取消并结束当前执行模块
func cancel(task: ProcessTask, msg: Dictionary = {}):
	_cancel(task, msg)
	finished.emit(false, msg)

func destroy():
	write_to_members.clear()
	for conn in finished.get_connections():
		finished.disconnect(conn)
	for conn in execution.get_connections():
		execution.disconnect(conn)

func _execute(task: ProcessTask, msg: Dictionary = {}):
	pass

func _completed(_task: ProcessTask, _msg: Dictionary = {}):
	pass

func _cancel(_task: ProcessTask, _msg: Dictionary = {}):
	pass
