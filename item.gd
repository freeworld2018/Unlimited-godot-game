extends RigidBody2D

#可以掉落的 捡起来的物品

var item_name:String
var price:float
var type:int
var pic:String
var id:int

func set_info(info:Array):
	item_name = info[0]
	type = info[1]
	pic  = info[2]
	id   = info[3]
	$Sprite2D.texture = load(pic)
	
func get_info():
	var info =[]
	info.append(item_name)
	info.append(type)
	info.append(pic)
	info.append(id)
	return info
func get_id():
	return id
