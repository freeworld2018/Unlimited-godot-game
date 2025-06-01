extends RigidBody2D

#可以掉落的 捡起来的物品
var self_item:item 
var in_bag:bool = false


func set_in_bag(value:bool):
	in_bag = value
	self.freeze = in_bag


func set_info(info:item):
	self_item = info
	match self_item.type:
		0:$Sprite2D.texture = load(self_item.pic)
		1:
			$Sprite2D.texture = load(self_item.pic)
			$Sprite2D.set_hframes(16)
			$Sprite2D.set_vframes(8)
			$Sprite2D.set_frame(self_item.picset_id-1)
		2:
			$Sprite2D.texture = load(self_item.pic)
			$Sprite2D.set_hframes(16)
			$Sprite2D.set_vframes(8)
			$Sprite2D.set_frame(self_item.picset_id-1)
			#var a = AtlasTexture.new()
			#a.atlas = load(self_item.pic)
			#$Sprite2D.texture = a
		

func get_id():
	return self_item.id
