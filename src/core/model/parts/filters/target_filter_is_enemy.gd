class_name TargetFilterEnemy extends TargetFilter

func _filter(source):
	if source is Card:
		# 相对于谁是敌人？？？  filter只有一个source不够用，至少需要拓展一个target 将原本的source作为target 而source应该保持不变，一直都是自己
		return source.holder.plays
	lg.warning("Unknow source type")
	return null
