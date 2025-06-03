## 流程任务组
##
## 基于[ProcessTask]的拓展类，用于管理多个[ProcessTask]子任务。[br]
## [br]
## [ProcessTaskBatch]的执行模块[ProcessTaskExecutor]不再可通过[ProcessTemplate]配置，而是固定由[ProcessTaskExecutorBatch]代理。[br]
## [br]
## 和[ProcessTask]一样，[ProcessTaskBatch]仍然可以被做为一个普通[BaseState]被[BaseStateMachine]所管理[br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskBatch
extends ProcessTask

## 子状态机，用于管理被添加到当前[ProcessTaskBatch]的子任务集
var private_state_machine: BaseStateMachine = BaseStateMachine.new()
## 子任务集数组容器，该数组的下标即为被添加进当前流程任务组的时序
var tasks: Array[ProcessTask]               = []

## 构造方法，和[ProcessTask]一样只能直接创建，不同之处在于只可以传入一个[ProcessTaskRouter]。
func _init(_router: ProcessTaskRouter):
	super._init(ProcessTaskExecutorBatch.new(),_router)
	private_state_machine.is_debug = true

## 添加子任务 [param task_id]：子任务在当前流程组的唯一ID。[param new_task]：需要添加的子任务
func add_task(task_id: StringName, new_task: ProcessTask) -> void:
	if is_active:
		push_error("ProcessTaskBatch %s is active!" % state_id)
		return
	tasks.append(new_task)
	new_task.parent = self
	private_state_machine.add_state(task_id, new_task)


func _exit() -> void:
	# 通常如果子状态机正常结束，
	# 如果是被外部手动调用，需要主动停止状态机
	if private_state_machine.is_active:
		private_state_machine.stop()

func _set_state_id(value:StringName) -> void:
	private_state_machine.state_id = value

func _get_state_id() -> StringName:
	return private_state_machine.state_id
