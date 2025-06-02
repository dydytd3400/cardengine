## 流程任务模版
##
## [ProcessTemplate]是一个流程任务模板配置类，负责动态化创建[ProcessTask]和[ProcessTaskBatch]
class_name ProcessTemplate
extends RefCounted

## 当前节点ID
## [b]必填[/b]
var key: String
## 当前节点的子节点
## [i]可选，默认为：空[/i]
var nodes: Array[ProcessTemplate]
## 当前节点的[ProcessTaskExecutor]
## [member ProcessTemplate.nodes]为[null]时[b]必填[/b]
var executor_source: String
## 当前节点的路由
## [i]可选，默认为：[/i][ProcessTaskRouterSequential]
var router_source: String


#TODO 该属性应该属于可编辑模版的拓展字段，不应该在基础模版体现
#var name: String # 当前节点显示名称 [b]必填[/b]
#var disable: int   = 0 # 当前节点是否禁用 0:不可禁用 1:禁用 -1:启用 [i]可选，默认为：[/i] [0]
#var sortable: bool = false  # 当前节点是否允许被排序 [i]可选，默认为：[/i] [false]
#var description: String # 当前节点描述 [i]可选，默认为：[/i] [null]

## 对当前已经填充的配置属性进行初步合法性校验
func validation()->bool:
	if !key or key.is_empty():
		lg.fatal("Template key empty!")
		return false
	if !nodes || nodes.is_empty():
		if !executor_source || executor_source.is_empty():
			lg.fatal("Template executor empty!")
			return false
	return true

## 填充配置项
## [param config] 配置字典 会验证整个配置字典的合法性
func populate(config: Dictionary)->bool:
	if !config or config.is_empty():
		lg.fatal("Template config empty!")
		return false
	if !config.has("key") or config.key.is_empty():
		lg.fatal("Template key empty!")
		return false
	key = config.key
	if config.has("executor"):
		executor_source = config.executor
	if config.has("router"):
		router_source = config.router
	if config.has("nodes"):
		var nodes_dict: Array   = config.nodes
		if nodes_dict.is_empty() && (!executor_source || executor_source.is_empty()):
			lg.fatal("Template config executor!")
			return false
		var key_map: Dictionary = {}
		for node in nodes_dict:
			var template = ProcessTemplate.new()
			if key_map.has(node.key):
				lg.fatal("Template nodes key repeated: [%s]" % node.key)
				return false
			if template.populate(node):
				nodes.append(template)
				key_map[node.key] = 1
	return true

## 填充配置项并生成对应的流程任务
## [param config] 配置字典 不为空时会验证整个配置字典的合法性，否则会只当对前已经填充的配置属性进行合法性校验
func generate(config: Dictionary = {})->ProcessTask:
	# 如果没有指定初始字典，则验证实例数据
	if !config or config.is_empty():
		if !validation():
			return null
	elif !populate(config): # 否则填充初始数据
		return null
	# 此时实例数据已经初始化，开始依赖模版实例数据去生成节点
	if nodes and !nodes.is_empty():
		return _create_process_task_batch() # 如果子节点数不为空 则创建流程任务组
	else:
		return _create_process_task() # 否则创建单个流程任务


## 创建流程任务组
func _create_process_task_batch() -> ProcessTaskBatch:
	var current_node := ProcessTaskBatch.new(_create_process_router())
	current_node.state_id = key
	for node in nodes:
		current_node.add_task(node.key, node.generate())
	return current_node

## 创建流程任务
func _create_process_task() -> ProcessTask:
	var current_node = ProcessTask.new(_create_process_executor(), _create_process_router())
	current_node.state_id = key
	return current_node

## 创建流程任务执行模块
func _create_process_executor() -> ProcessTaskExecutor:
	var executor:ProcessTaskExecutor
	# 当前节点为普通流程任务时，才能自定义任务执行器和任务路由
	if executor_source and !executor_source.is_empty():
		executor = load(executor_source).new()
	else:
		lg.fatal("Template executor empty!")
		return null
	if !executor:
		lg.fatal("Template executor load error!")
		return null
	if !(executor is ProcessTaskExecutor):
		lg.fatal("Template executor type error!")
		return null
	return executor

## 创建流程任务路由
func _create_process_router() -> ProcessTaskRouter:
	var router
	if router_source and !router_source.is_empty():
		router = load(executor_source).new()
	else:
		router = _creator_default_router()
	return router

## 创建流程任务默认路由
func _creator_default_router() -> ProcessTaskRouter:
	return ProcessTaskRouterSequential.new()


func _init(config: Dictionary = {}):
	if config && !config.is_empty():
		populate(config)
