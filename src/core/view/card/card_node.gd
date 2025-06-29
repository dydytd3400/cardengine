@icon("res://assets/textures/blank_red.png")
class_name CardNode
extends PanelContainer

@export
var card_name_node:Label
@export
var cost_node:AttributeNode
@export
var attack_node:AttributeNode
@export
var health_node:AttributeNode
@export
var card_text_node:Label
@export
var frame_node:TextureRect

## 卡牌名称
var card_name: String:
	set(val):
		card_name_node.text=val

## 当前费用
var cost: int = 0:
	set(val):
		cost_node.value=val
## 初始费用
var cost_max: int = 0:
	set(val):
		cost_node.initial_value=val

## 当前血量
var health: int = 0:
	set(val):
		health_node.value=val
## 初始血量
var health_max: int = 0:
	set(val):
		health_node.initial_value=val

## 当前攻击力
var attack: int = 0:
	set(val):
		attack_node.value=val
## 初始血量
var attack_max: int = 0:
	set(val):
		attack_node.initial_value=val

## 可攻击区域 以自身为中心的相对坐标
var attack_area: Array[Vector2] = []
## 攻击方式
var attack_type: Ability

## 移动距离 单次移动可移动的最大格数
var mobility: int = 0
## 初始移动距离
var mobility_max: int = 0
## 可移动区域 以自身为中心的相对坐标
var move_area: Array[Vector2] = []
## 移动方式
var move_type: Ability

## 能力集
var abilitys: Array[Ability] = []
## 卡牌描述
var text: String:
	set(val):
		card_text_node.text=val

## 卡牌边框
var frame_style:String:
	set(val):
		var frame_res = load("res://assets/textures/"+val+".png")
		var a :CompressedTexture2D
		if frame_res:
			frame_node.texture = frame_res

var activated = false

var showing = true:
	set(val):
		showing = val
		$CardBack.visible = !showing
		$Attributes.visible = showing

func death():
	await TweenUtil.size_to(self,0.5,Vector2.ZERO)


var top_scale:float:
	set(val):
		top_scale = val
		_top_scale(val)

func _top_scale(scale:float):
	material.set_shader_param("top_scale", scale)
