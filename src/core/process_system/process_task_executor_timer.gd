## 流程任务定时执行模块
##
## 根据[member duration]设置的时间间隔(秒)来执行[method _execute]，如果[member loop]设置为[code]true[/code]，则会周期执行。此时如果[member repeat]大于0，则会在执行指定次数后停止
## 当执行模块结束，定时任务会停止。你也可以手动调用[method stop_timer]、[method pause_timer]、[method resume_timer]来停止、暂停、恢复定时任务
## @experimental: 该方法尚未完善。
class_name ProcessTaskExecutorTimer
extends ProcessTaskExecutor

## 时间间隔
var duration: float
## 是否开启任务循环 默认不开启
var loop: bool = false
## 定时任务重复执行次数 仅[code]loop = true && repeat > 0[/code]时生效。当定时任务停止后次数会被重置
var repeat:int = 0

## 定时器ID 不建议手动复制
var _timer_id = UUID.generate()
## 已执行次数记录 不建议手动复制
var _run_count = 0

## 创建并启动定时任务
func execute(task: ProcessTask, msg: Dictionary = {}) -> void:
	stop_timer(true)
	if duration <= 0:
		lg.fatal("Duration must > 0!")
		return
	CoreSystem.time_manager.create_timer(_timer_id,duration,loop,
		func ():
			_run_count+=1
			if !loop || _run_count >= repeat :
				stop_timer(true)
			_execute(task,msg)
	)

## 完成并结束当前执行模块,该方法会停止之前正在执行的定时任务
func complated(task: ProcessTask, msg: Dictionary = {}):
	stop_timer(true)
	super.complated(task,msg)

## 取消并结束当前执行模块,该方法会停止之前正在执行的定时任务
func cancel(task: ProcessTask, msg: Dictionary = {}):
	stop_timer(true)
	super.cancel(task,msg)

## 停止计时任务
func stop_timer(unlog:bool = false):
	_run_count = 0
	if CoreSystem.time_manager.has_timer(_timer_id):
		CoreSystem.time_manager.remove_timer(_timer_id)
	elif !unlog:
		lg.warning("Timer is unstarted.")

## 暂停计时任务
func pause_timer(unlog:bool = false):
	if CoreSystem.time_manager.has_timer(_timer_id):
		CoreSystem.time_manager.pause_timer(_timer_id)
	elif !unlog:
		lg.warning("Timer is unstarted.")

## 恢复计时任务
func resume_timer(unlog:bool = false):
	if CoreSystem.time_manager.has_timer(_timer_id):
		CoreSystem.time_manager.resume_timer(_timer_id)
	elif !unlog:
		lg.warning("Timer is unstarted.")

func _execute(task: ProcessTask, msg: Dictionary = {}):
	lg.info("Execute Task to do something " + task.state_id)
	if _run_count == 0:
		complated(task, msg) # 默认流程任务执行者的逻辑是直接完成了当前任务，根据自身需求重载该方法
