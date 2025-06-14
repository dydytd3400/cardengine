## 流程任务
##
## 相对于[BaseState]，[ProcessTask]拆分出了专注于具体业务逻辑的执行模块类[ProcessTaskExecutor]和负责自身状态切换的任务路由类[ProcessTaskRouter]。
## [ProcessTask]不参与除自身状态管理以外的具体逻辑，而是分别交给[ProcessTaskExecutor]和[ProcessTaskRouter]各自负责处理，从而实现进一步解耦。
## 通过结合流程模版[ProcessTemplate]配置[ProcessTask]，可实现动态化管理任务模块，具体参考流程模版配置类[ProcessTemplate]。[br][br]
## [ProcessTask]仍然可以被视作一个普通的[BaseState]被[BaseStateMachine]所管理
## @experimental: 该方法尚未完善。
class_name ProcessTask
extends BaseState

## 当前[ProcessTask]的执行模块
var executor: ProcessTaskExecutor
## 当前[ProcessTask]的路由模块
var router: ProcessTaskRouter

## 当前[ProcessTask]的父级节点。它可能是[ProcessTaskBatch]或[BaseStateMachine]，并且可以为[code]null[/code]。
var parent: Variant:
	set(value): parent = value
	get: return parent if parent else state_machine

## 构造方法，需要传入[ProcessTaskExecutor]和[ProcessTaskRouter]，也就预示着[ProcessTask]只能直接创建
func _init(_executor: ProcessTaskExecutor, _router: ProcessTaskRouter):
	executor = _executor
	router = _router
	state_entered.connect(on_entered)
	_initial_executor()

func _initial_executor():
	executor.finished.connect(_executor_finished)
	#executor.finished.connect(router.next)

#### 进入当前任务状态
#### 调度[member executor]执行具体任务，并通过[param msg]附带上下文参数，该参数如果没有被修改，通常会被一直传递直到流程结束
#func enter(msg: Dictionary = {}) -> bool:
	#if super.enter(msg):
		#executor.execute(self, msg)
		#return true
	#return false

#func execute_at(obj:Variant,msg: Dictionary = {}):
	#obj.excute
	#enter(msg)

func enter(msg: Dictionary = {}) -> bool:
	print("当前栈深[enter]=================================>>>>  "+str(get_stack().size()))
	return super.enter(msg)

func exit() -> bool:
	print("当前栈深[exit]=================================>>>>  "+str(get_stack().size()))
	return super.exit()

func on_entered(msg: Dictionary):
	#if msg.has("battle_field"):
		#var b:BattleField = msg.battle_field
		#b.execute(executor,self,msg)
	#else:
		executor.execute(self, msg)
		print("当前栈深[execute]=================================>>>>  "+str(get_stack().size()))

## 切换流程任务
func switch_to(state_id: StringName, msg: Dictionary = {}) -> void:
	if parent:
		if parent is BaseStateMachine:
			super.switch_to(state_id, msg)
			return
		elif parent is ProcessTaskBatch:
			parent.switch(state_id, msg)
			return
	lg.warning("Unexpected call!")
	super.switch_to(state_id, msg)


## 通过task_id获取同级任务
func get_parent_task(task_id: StringName) -> ProcessTask:
	if parent:
		if parent is ProcessTaskBatch:
			return parent.get_task(task_id)
		elif parent is BaseStateMachine:
			return parent.states[task_id]
	lg.warning("Has no parent")
	return null

# 当前executor执行完毕，路由至下一个流程任务
func _executor_finished(task:ProcessTask, completed: bool, msg: Dictionary) -> void:
	router.next(self, completed, msg) # 路由至下一个流程任务
