extends Node

var item_group = []


func _ready() -> void:
	var a = FileAccess.open("res://data/data_item.json",FileAccess.READ)
	var c = JSON.parse_string(a.get_as_text())
	a.close()
	#var id_count:int = 0
	for i in c:
		var item_a = item.new()
		item_a.item_name = i["item_name"]
		item_a.type = i["type"]
		item_a.pic = i["pic"]
		item_a.id = i["id"]
		item_a.stack = i["stack"]
		item_a.picset_id = i["piscset_id"]
		#item_a.effect = i["effect"]
		item_group.append(item_a)
func item_info(id:int):
	#通过id寻找物品
	if id < 0 or  id>=len(item_group):
		return item_group[0].clone()
	else:
		return item_group[id].clone()

func get_pic(id:int):
	if id < 0 or  id>=len(item_group):
		return [item_group[0].pic,0]
	else:
		if item_group[id].type != 0:
			return [item_group[id].pic,item_group[id].picset_id]
		return [item_group[id].pic,0]
