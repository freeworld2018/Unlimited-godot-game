extends Sprite2D

var self_item:item
var quantity:int = 1
func set_quantity(num:int):
	quantity = num
	if quantity == 1:
		$Label.text = ""
		return
	$Label.text = str(quantity)
func add(num:int):
	quantity += num
	if quantity == 1:
		$Label.text = ""
		return
	$Label.text = str(quantity)
func reduce(num:int):
	quantity -= num
	if quantity == 1:
		$Label.text = ""
		return
	$Label.text = str(quantity)
func set_info(info:item):
	self_item = info
	match self_item.type:
		0:self.texture = load(self_item.pic) #枪械
		1:#食品
			self.texture = load(self_item.pic)
			self.set_hframes(16)
			self.set_vframes(8)
			self.set_frame(self_item.picset_id-1)
		2:#水
			self.texture = load(self_item.pic)
			self.set_hframes(16)
			self.set_vframes(8)
			self.set_frame(self_item.picset_id-1)
		3:#近战
			self.texture = load(self_item.pic)
			#var image_icon = load(self_item.pic).get_image()
			#image_icon.resize(64,64)
			#self.texture = ImageTexture.create_from_image(image_icon)
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
