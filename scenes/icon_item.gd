extends Sprite2D

var self_item:item


func set_info(info:item):
	self_item = info
	match self_item.type:
		0:self.texture = load(self_item.pic)
		1:
			self.texture = load(self_item.pic)
			self.set_hframes(16)
			self.set_vframes(8)
			self.set_frame(self_item.picset_id-1)
		2:
			self.texture = load(self_item.pic)
			self.set_hframes(16)
			self.set_vframes(8)
			self.set_frame(self_item.picset_id-1)
			#var a = AtlasTexture.new()
			#a.atlas = load(self_item.pic)
			#self.texture = a
func get_id():
	return self_item.id
func info():
	var a = []
	a.append(self_item.name)
	a.append(self_item.type)
	a.append(self_item.pic)
	a.append(self_item.id)
	a.append(self_item.stack)
	return a
