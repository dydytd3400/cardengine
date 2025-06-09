## 抽牌执行模块
## @experimental: 该方法尚未完善。需要理清楚 Effect和Executor的关系，目前来看 抽卡意图和抽卡Effect非常雷同，看看是否需要彻底区分或者合并这两个概念。可能仍然需要做拆分，因为不同的抽牌行为具有不同的UI表现以及数据引用和触发
class_name DrawCard
extends ProcessTaskExecutor

## 抽牌数量
var count = 1
## 当前触发此次抽牌行为的目标的UUID 通常由上下文携带
var trigger_id: StringName = &""
## 卡牌池来源玩家类型[br]
## 暂定为"current_player"和"next_player"，即此次抽牌行为的当前回合的当前玩家或对手玩家。由于使用了[member trigger_id]标定了触发者，所以以相对目标的方式去标定玩家也不会混淆。
var source_player_type = "current_player"
## 卡牌池来源的类型，包含[member Player.deck]、[member Player.hand]、[member Player.plays]、[member Player.graveyard]、[member Player.trashed]、[member Player.cards]等
var source_cards_type = "deck"
## 目标玩家的卡牌池类型[br]
var target_player_type = "current_player"
## 放入目标卡牌池的类型
var target_cards_type = "hand"

func _execute(task: ProcessTask, msg: Dictionary = {}):
	if !source_player_type:
		lg.fatal("\"source_player_type\" is Empty")
		return
	if source_player_type != "current_player" && source_player_type != "next_player":
		lg.fatal("\"source_player_type\" must \"current_player\" or \"next_player\"")
		return
	var battle_field: BattleField = msg.battle_field
	if msg.has("trigger_id"):
		trigger_id = msg["trigger_id"]
	var trig_player: Player = battle_field.find_player(trigger_id)
	var _source_player: Player = battle_field[source_player_type]
	var cards = _source_player[source_cards_type]
	var _draws = draw_card(cards, count)

	var _target_player = battle_field[target_player_type]
	var _target_cards: Array[Card] = _target_player[target_cards_type]
	_target_cards.append_array(_draws)
	# match source_cards_type:
	# 	"hand":


	lg.info("%s:从%s的%s抽%d张牌到%s的%s" % ["玩家" if trig_player!=null else "系统",
											_source_player.player_name,
											source_cards_type,
											count,
											_target_player.player_name,
											target_cards_type],{},"BattleProcess")
	#var time = randf_range(1, 8)
	#lg.info(str(time) + "秒后结束",{},"BattleProcess")
	#CoreSystem.time_manager.create_timer(UUID.generate(), time, false, func(): completed(task, msg))
	completed(task, msg)

func draw_card(source: Array[Card], _count: int) -> Array[Card]:
	var _draws: Array[Card] = []
	if source.is_empty():
		return _draws
	var real_count = min(_count, source.size())
	for i in range(real_count):
		_draws.append(source.pop_at(randi_range(0, real_count - 1 - i)))
	return _draws
