## 基础状态类
class_name BaseState
extends RefCounted

# 信号
## 状态进入
signal state_entered(msg: Dictionary)
## 状态退出
signal state_exited

var _state_id : StringName = &""
var state_id : StringName :
	set(value): _set_state_id(value)
	get: return _get_state_id()

## 状态机引用
var state_machine : BaseStateMachine = null
## 代理者
var agent: Object = null : set = _agent_setter

## 是否活跃
var is_active: bool = false
var _is_ready

var is_debug: bool = false
var _logger : CoreSystem.Logger = CoreSystem.logger

func ready() -> void:
	if _is_ready:
		_logger.warning("State is already ready!")
		return
	_ready()
	_is_ready = true

func dispose() -> void:
	_dispose()
	_is_ready = false

## 进入状态
func enter(msg: Dictionary = {}) -> bool:
	if is_active:
		_logger.warning("State[%s] is already active!" % state_id)
		return false
	is_active = true
	_enter(msg)
	_debug("Entering state: %s" % state_id)
	state_entered.emit(msg)
	return true

## 退出状态
func exit() -> bool:
	if not is_active:
		_logger.warning("State[%s] is not active!" % state_id)
		return false
	_exit()
	is_active = false
	_debug("Exiting state: %s" % state_id)
	state_exited.emit()
	return true

## 更新
func update(delta: float) -> void:
	if not is_active:
		return
	_update(delta)

## 物理更新
func physics_update(delta: float) -> void:
	if not is_active:
		return
	_physics_update(delta)

## 处理事件
func handle_input(event: InputEvent) -> void:
	if not is_active:
		return
	_handle_input(event)

## 切换状态
func switch_to(state_id: StringName, msg: Dictionary = {}) -> void:
	if not state_machine:
		_logger.error("State machine is not set!")
		return

	if not state_machine.has_state(state_id):
		_logger.error("State %s does not exist!" % state_id)
		return

	if state_machine:
		state_machine.switch(state_id, msg)

## 获取变量
func get_variable(key: StringName) -> Variant:
	if state_machine:
		return state_machine.get_variable(key)
	return null

## 设置变量
func set_variable(key: StringName, value: Variant) -> void:
	if state_machine:
		state_machine.set_variable(key, value)

## 检查变量是否存在
func has_variable(key: StringName) -> bool:
	if state_machine:
		return state_machine.has_variable(key)
	return false

## 获取状态树ID
func get_state_id_tree() -> Array[StringName]:
	var state_ids:Array[StringName] = []
	var cur_state = self
	while cur_state:
		state_ids.insert(0,cur_state.state_id)
		cur_state = cur_state.state_machine
	return state_ids

## 获取并拼接状态树ID
func get_state_id_tree_str() -> String:
	var state_id_tree: Array[StringName] = get_state_id_tree()
	var state_ids: String                = ""
	var i = 0
	for id in state_id_tree:
		i+=1
		if i<state_id_tree.size():
			state_ids += id + "-"
		else:
			state_ids += id + " -> "
	return state_ids

## 虚函数 - 准备
func _ready() -> void:
	pass

## 虚函数 - 清理
func _dispose() -> void:
	pass

## 虚函数 - 进入状态
func _enter(_msg: Dictionary = {}) -> void:
	pass

## 虚函数 - 退出状态
func _exit() -> void:
	pass

## 虚函数 - 更新
func _update(_delta: float) -> void:
	pass

## 虚函数 - 物理更新
func _physics_update(_delta: float) -> void:
	pass

## 虚函数 - 处理输入
func _handle_input(_event: InputEvent) -> void:
	pass


func _debug(debug: String) -> void:
	if not is_debug:
		return
	_logger.debug("[State] " + get_state_id_tree_str() + ": " + debug)


func _agent_setter(value: Object) -> void:
	agent = value

func _set_state_id(value:StringName) -> void:
	_state_id = value

func _get_state_id() -> StringName:
	return _state_id
