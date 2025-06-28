class_name TriggerDispatcher extends Node


var triggers:Dictionary[StringName,Array]

## 初始化触发信号派发器
func initialize(_table: Table,_players:Array[Player]):
	for player in _players:
		for card in player.deck: # 为玩家牌库的卡牌注册状态监听
			card.states.state_changed.connect(card_state_changed.bind(card))
		   # 为玩家自身绑定触发器
		bind_trigger(player.bury_ability.trigger)

## 卡牌状态监听
func card_state_changed(_from_state: BaseState, _to_state: BaseState, _msg: Dictionary, triggerer: Card):
	# 如果当前状态是进入TABLE 则为当前触发该状态变化的卡牌绑定触发器
	if _to_state.state_id == CardState.TABLE:
		if triggerer.move_type:
			bind_trigger(triggerer.move_type.trigger)
		if triggerer.attack_type:
			bind_trigger(triggerer.attack_type.trigger)
		if triggerer.abilitys && !triggerer.abilitys.is_empty():
			for ability in triggerer.abilitys:
				bind_trigger(ability.trigger)

	# 从已经绑定的触发器中派发触发信号
	var _triggers:Array=triggers.get(_to_state.state_id,[])
	for trigger in _triggers:
		trigger.on_triggered(triggerer,_msg)

	# 如果卡牌进入消耗状态或撕毁状态，则解除绑定 （该状态解除绑定需要在状态已经派发之后）
	if _to_state.state_id == CardState.USED || _to_state.state_id == CardState.TRASHED:
		if triggerer.move_type:
			unbind_trigger(triggerer.move_type.trigger)
		if triggerer.attack_type:
			unbind_trigger(triggerer.attack_type.trigger)
		if triggerer.abilitys && !triggerer.abilitys.is_empty():
			for ability in triggerer.abilitys:
				unbind_trigger(ability.trigger)

## 玩家状态监听
func player_state_changed(_from_state: BaseState, _to_state: BaseState, _msg: Dictionary, triggerer: Player):
	var _triggers:Array=triggers.get(_to_state.state_id,[])
	for trigger in _triggers:
		trigger.on_triggered(triggerer,_msg)

## 系统状态监听
func sysytem_state_changed(process_id: StringName, _msg: Dictionary):
	var _triggers:Array=triggers.get(process_id,[])
	for trigger in _triggers:
		trigger.on_triggered(null,_msg)

## 绑定触发器
func bind_trigger(trigger:Trigger):
	if !triggers.has(trigger.trigger_name):
		triggers.set(trigger.trigger_name,[])
	var _triggers:Array=triggers.get(trigger.trigger_name)
	if _triggers.find(trigger)>=0:
		lg.warning("Repeated binding trigger %s" % trigger.trigger_name)
		return
	_triggers.append(trigger)

## 解绑触发器
func unbind_trigger(trigger:Trigger):
	if !triggers.has(trigger.trigger_name):
		triggers.set(trigger.trigger_name,[])
	var _triggers:Array=triggers.get(trigger.trigger_name)
	var at = _triggers.find(trigger)
	if at<0:
		lg.warning("Not Exsit binded trigger %s" % trigger.trigger_name)
		return
	_triggers.remove_at(at)
