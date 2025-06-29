extends Resource
## 场景数据资源，主要用于存档功能
class_name BattleFieldData

@export
var players: Array[PlayerData] = []
@export
var turn_count: int = 0
@export
var first_index: int = -1
@export
var current_player_index: int = -1
