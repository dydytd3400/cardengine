extends Object
class_name Player

var name:String
var id:int
#var cards:Array[Card] = []

var _health: int      = 0
var _gold: int        = 0
var _nickname: String = ""
var player_id: String = ""


#var controller:TableController:
	#get:
		#return battlefield.table_controller
#var slots:Array[CardSlot]:
	#get: return controller.slot_of_player[player_id]
#
#var slot_not_emptys:Array[CardSlot]:
	#get: return slots.filter(func (item:CardSlot): return !item.is_empty())
#
#var inbattles:Array[Card]:
	#get: return slot_not_emptys.map(func (item:CardSlot): return item.card)
#
#var cards:Array[Card]:
	#get: return _hand._cards + _deck._cards + inbattles + _tomb._cards
#
#var sync_task:SyncTask = SyncTask.new(self)
#
#func is_self()->bool:
	#return battlefield.self_player_id == player_id
#
#func is_player()->bool:
	#return battlefield.players[0].player_id == player_id
#
#func is_enemy()->bool:
	#return battlefield.players[1].player_id == player_id
#
#func enemy()->Player:
	#if battlefield.players[0] == self:
		#return battlefield.players[1]
	#return battlefield.players[0]
#
#func on_bind_data():
	#player_id = _data.player_id
