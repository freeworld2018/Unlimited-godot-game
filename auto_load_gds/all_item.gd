extends Node

var item_group = []


func _ready() -> void:
	#读取json for循环
	var a = item.new()
	a.name="pistol"
	a.type=0
	a.pic= "res://gane_assets/art/weapon/pistol.png"
	a.id = 0
	item_group.append(a)

func item_info(id:int):
	#通过id寻找物品
	if id < 0 or  id>len(item_group):
		return item_group[0]
	else:
		return item_group[id]
