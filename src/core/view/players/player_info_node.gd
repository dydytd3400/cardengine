extends Control
class_name PlayerInfoNode

var player_name:String:
	set(value):$NickName.text=value

var health_max:int:
	set(value):
		$Health.max_value=value
		$Health/HealthLabel.text = "%d/%d" % [$Health.value,value]

var health: int:
	set(value):
		$Health.value=value
		$Health/HealthLabel.text = "%d/%d" % [value,$Health.max_value]
var face:Texture2D:
	set(value):$FaceTexture.texture=value
