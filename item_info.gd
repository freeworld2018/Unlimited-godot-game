extends RigidBody2D

#可以掉落的 捡起来的物品
var self_item:item 
var in_bag:bool = false


func set_in_bag(value:bool):
	in_bag = value
	self.freeze = in_bag


func set_info(info:item):
	self_item = info
	$Sprite2D.texture = load(self_item.pic)

func get_id():
	return self_item.id
