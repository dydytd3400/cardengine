## 流程任务路由
##
## 当[ProcessTask]退出后，会通过[method _find_next]去路由到下一个[ProcessTask][br]
## 可通过[ProcessTemplate]自定义配置包括[ProcessTaskBatch]的所有[ProcessTask]的[ProcessTaskRouter][br]
## 只允许在同级流程任务之间进行路由[br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskRouter
extends ProcessTaskReader

## 当前任务结束时，会通过该方法调用[method _find_next]找到下一个同级流程任务并在当前方法路由[br]
## 如果[method _find_next]返回空，则流程任务会挂起，直到[method next]被再次执行或退出了当前流程任务。如果返回的流程任务没有父节点，则会直接退出当前流程任务。
func next(current_task: ProcessTask, completed: bool, msg: Dictionary = {}) -> void:
	write_to_member(msg)
	var next_task := _find_next(current_task, completed, msg)
	if next_task == current_task: # 返回自身 则表示当前任务尚未彻底结束 挂起
		return
	var parent = current_task.parent
	if next_task:
		if !parent:
			lg.warning("Has no parent, [%s] exit and [%s] enter" % [current_task.state_id, next_task.state_id])
			current_task.exit()
			next_task.enter(msg)
		#elif !(parent is ProcessTaskBatch && parent.concurrent): # 当前任务不是并发子任务时，进行路由，否则不做处理
			#current_task.switch_to(next_task.state_id,msg)
		elif parent is ProcessTaskBatch:
			if !parent.concurrent:
				current_task.switch_to(next_task.state_id, msg)
			else:
				current_task.exit()
	else: # 返回空 当前任务退出，并通知父节点完成相应任务
		if parent:
			if parent is ProcessTaskBatch:
				if !parent.concurrent: # 如果父节点为流程任务组，且为非并发任务 则表示父节点执行模块已经结束，父节点进入路由
					parent.executor.completed(current_task, msg)
					return
			elif parent is BaseStateMachine:
				parent.stop()
				return
		current_task.exit()


## 返回下一个同级流程任务
func _find_next(_current_task: ProcessTask, _completed: bool, _msg: Dictionary = {}) -> ProcessTask:
	return null
