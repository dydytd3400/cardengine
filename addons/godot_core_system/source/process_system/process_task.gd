## 流程任务
##
## 相对于[BaseState]，[ProcessTask]拆分出了专注于具体业务逻辑的执行模块类[ProcessTaskExecutor]和负责自身状态切换的任务路由类[ProcessTaskRouter]。
## [ProcessTask]不再参与除自身状态管理以外的具体逻辑，而是分别交给[ProcessTaskExecutor]和[ProcessTaskRouter]各自负责处理，从而实现进一步解耦。
## [ProcessTask]可通过结合流程模版[ProcessTemplate]配置[ProcessTask]，实现动态化管理任务模块，具体参考流程模版配置类[ProcessTemplate]。[br][br]
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
func _init(_executor: ProcessTaskExecutor,_router: ProcessTaskRouter):
	executor = _executor
	router = _router
	state_entered.connect(_task_entered)
	executor.finished.connect(_executor_finished)

## 进入当前任务状态
## 调度[member executor]执行具体任务，并通过[param msg]附带参数
func _task_entered(msg := {}) -> void:
	executor.execute(self, msg)


## 当前[member executor]执行完毕，路由至下一个流程任务
func _executor_finished(completed: bool, msg: Dictionary) -> void:
	router.next(self, completed, msg) # 路由至下一个流程任务
