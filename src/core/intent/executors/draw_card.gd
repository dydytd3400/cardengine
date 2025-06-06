extends ProcessTaskExecutor
class_name DrawCard
# TODO 需要理清楚 Effect和Executor的关系，目前来看 抽卡意图和抽卡Effect非常雷同，看看是否需要彻底区分或者合并这两个概念
var count = 0
var source_player_type = "current_player" # 用ID就表示绝对，也就意味着不可配置  但是用当前 逻辑难以理顺 要重新思考一下 或者考虑用 players index。 因为用current_player这种相对取值方式，如果该抽卡行为是当前玩家触发了敌方技能，导致敌方在当前玩家回合进行了抽卡，那么就会有问题
var source_cards_type = "deck" #
var target_player_type = "current_player"
var target_cards_type = "hand"

func _execute(task: ProcessTask, msg: Dictionary = {}):
	if !source_player_type:
		lg.fatal("\"source_player_type\" is Empty")
		return
	if source_player_type != "current_player" && source_player_type != "next_player":
		lg.fatal("\"source_player_type\" must \"current_player\" or \"next_player\"")
		return

	var battle_field: BattleField = msg.battle_field
	var _source_player: Player = battle_field[source_player_type]
	var cards = _source_player[source_cards_type]
	var _draws = draw_card(cards, count)

	var _target_player = battle_field[target_player_type]
	var _target_cards: Array[Card] = _target_player[target_cards_type]
	_target_cards.append_array(_draws)
	# match source_cards_type:
	# 	"hand":


	lg.info("玩家:%s从%s的%s抽%d张牌到%s的%s" % [battle_field.current_player.player_name,
											_source_player.player_name,
											source_cards_type,
											count,
											_target_player.player_name,
											target_cards_type])
	var time = randf_range(1, 8)
	lg.info(str(time) + "秒后接受")
	CoreSystem.time_manager.create_timer(UUID.generate(), time, false, func(): completed(task, msg))

func draw_card(source: Array[Card], _count: int) -> Array[Card]:
	var _draws:Array[Card] = []
	if source.is_empty():
		return _draws
	var real_count = min(_count, source.size())
	for i in range(real_count):
		_draws.append(source.pop_at(randi_range(0, real_count - 1 - i)))
	return _draws
