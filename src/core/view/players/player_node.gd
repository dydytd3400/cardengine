@icon("res://assets/icons/player.svg")
class_name PlayerNode extends Control

@export
var player_info_node:PlayerInfoNode
@export
var golds_node:GoldsNode

## 玩家昵称
var player_name: String:
	set(value):player_info_node.player_name=value
## 当前血量
var health: int:
	set(value):player_info_node.health = value
var health_max:int:
	set(value):player_info_node.health_max = value

## 当前金币
var gold: int = 0:
	set(value):golds_node.gold=value

## 初始卡牌 该数据不可发生变化
var cards: Array[CardData]

## 当前牌库
var deck: Array[Card] = []
## 当前手牌
var hand: Array[Card] = []
## 当前牌桌上的卡牌
var plays: Array[Card] = []
## 当前墓堆
var graveyard: Array[Card] = []
## 废弃的卡
var trashed: Array[Card] = []
