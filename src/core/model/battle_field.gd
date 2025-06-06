extends Object
class_name BattleField

var players: Array[Player] = []
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
var next_player:Player:
	get():
		var next_index = 0 if current_player_index != 0 else 1
		return players[next_index]
var turn_count = 0

## 切换至下个玩家
func switch_next() -> Player:
	current_player_index = 0 if current_player_index != 0 else 1
	turn_count += 1
	return current_player

func pick_first() -> Player:
	first_index = randi_range(0,1)
	lg.info("当前先手玩家是 %s" % current_player.player_name)
	return current_player

func checkmate() ->bool:
	if turn_count < 10:
		switch_next()
		return false
	else:
		return true

func draw_card(player:Player,count:int = 1):
	return player.draw_card(count)

func _init():
	# 虚构基础数据
	players.append(create_player("张三"))
	players.append(create_player("李四"))

func create_player(name:String)->Player:
	var player:Player=Player.new()
	player.player_id = UUID.generate()
	player.player_name = name
	for i in 30:
		player.cards.append(create_card(i))
	return player

func create_card(name:int):
	var card :Card = Card.new()
	card.card_id = UUID.generate()
	card.card_name = "卡牌_"+str(name)
	card.attack = randi_range(0,10)
	card.attack_max = randi_range(0,10)
	card.cost = randi_range(0,10)
	card.cost_max = randi_range(0,10)
	card.health = randi_range(0,10)
	card.health_max = randi_range(0,10)
	return card
