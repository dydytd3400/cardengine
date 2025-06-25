class_name TriggerDispatcher extends Node


var triggers:Dictionary[StringName,Array]

func initialize(_table: Table,_players:Array[Player]):
	for player in _players:
		for card in player.deck:
			card.states.state_changed.connect(card_state_changed.bind(card))

func card_state_changed(_from_state: BaseState, _to_state: BaseState, _msg: Dictionary, triggerer: Card):
	if _to_state.state_id == CardState.TABLE:
		if triggerer.move_type:
			bind_trigger(triggerer.move_type.trigger)
		if triggerer.attack_type:
			bind_trigger(triggerer.attack_type.trigger)
		if triggerer.abilitys && !triggerer.abilitys.is_empty():
			for ability in triggerer.abilitys:
				bind_trigger(ability.trigger)

	var _triggers:Array=triggers.get(_to_state.state_id,[])
	for trigger in _triggers:
		trigger.on_triggered(triggerer,_msg)

func player_state_changed(_from_state: BaseState, _to_state: BaseState, _msg: Dictionary, triggerer: Player):
	var _triggers:Array=triggers.get(_to_state.state_id,[])
	for trigger in _triggers:
		trigger.on_triggered(triggerer,_msg)

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
