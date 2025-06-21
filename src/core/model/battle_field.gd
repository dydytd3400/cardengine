extends Node
class_name BattleField
var view: BattleFieldNode
var data: BattleFieldData

@export
var players: Array[Player] = []
@export
var table: Table

var turn_count = 0
var first_index = -1:
	set(value):
		first_index = value
		current_player_index = value
		current_player.is_first = true
		next_player.is_first = false
	get: return first_index
var current_player_index = -1
var current_player: Player:
	get(): return players[current_player_index]
var next_player: Player:
	get():
		var next_index = 0 if current_player_index != 0 else 1
		return players[next_index]
var index = 1

var trigger_dispatcher: TriggerDispatcher = TriggerDispatcher.new()

func initialize():
	lg.info("战斗开始，初始化双方玩家数据", {}, "BattleProcess")
	players[0].initialize()
	players[1].initialize()
	table.initialize(7, 4, players)
	trigger_dispatcher.initialize(table,players)
	players[0].init_deck()
	players[1].init_deck()

## 切换至下个玩家
func switch_next() -> Player:
	current_player_index = 0 if current_player_index != 0 else 1
	turn_count += 1
	return current_player

func pick_first() -> Player:
	first_index = randi_range(0, 1)
	lg.info("当前先手玩家是 %s" % current_player.player_name, {}, "BattleProcess")
	return current_player

func checkmate() -> bool:
	lg.info("第%d个回合结束" % turn_count, {}, "BattleProcess")
	if turn_count < 10:
		switch_next()
		return false
	else:
		lg.info("全部流程结束啦", {}, "BattleProcess")
		print("当前栈深=================================>  " + str(get_stack().size()))
		return true

func draw_card(player: Player, count: int = 1):
	return player.draw_card(count)

func find_player(_player_id: StringName) -> Player:
	for player in players:
		if player.player_id == _player_id:
			return player
	return null

func on_battle_process_changed(process_id:StringName,msg:Dictionary):
	lg.info("=============>>>>>>>>>"+process_id)
	trigger_dispatcher.sysytem_state_changed(process_id,msg)

# =====================================================

func create_player(_name: String) -> PlayerData:
	var player: PlayerData = PlayerData.new()
	player.player_id = UUID.generate()
	player.player_name = _name
	player.health = 100
	for i in range(30):
		var card = create_card(i)
		card.text = _name
		player.cards.append(card)
	return player

func create_card(_name: int):
	var card: CardData = CardData.new()
	card.card_id = UUID.generate()
	card.card_name = "卡牌_" + str(_name)
	card.attack = randi_range(0, 10)
	card.cost = randi_range(0, 10)
	card.health = randi_range(0, 10)
	card.card_type = DataEnums.CardType.CHARACTER
	card.mobility = 1
	card.move_type = AbilityMove.new()
	card.move_area = [Vector2i(0, 1), Vector2i(0, -1), Vector2i(-1, 0), Vector2i(1, 0)]
	card.attack_area = [Vector2i(0, 1), Vector2i(0, -1), Vector2i(-1, 0), Vector2i(1, 0)]
	return card

func _ready() -> void:
	# 虚构基础数据
	players[0].data = create_player("张三")
	players[1].data = create_player("李四")
	var process: ProcessTask = ProcessTemplate.new().generate(ProcessConfig.battle_process_config)
	process.process_changed.connect(on_battle_process_changed)
	process.enter({"battle_field" = self})

#func _init():
	#OS.set_stack_size(2048 )
