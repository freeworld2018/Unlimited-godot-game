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
	if quantity == 0:
		return true
	$Label.text = str(quantity)
	
func set_info(info:item):
	if info.id > 1000:
		self_item = info
		self.texture = AllItem.weapon_icon_pic_group[0]
		self.set_hframes(8)
		self.set_vframes(1)
		self.set_frame(self_item.type-5)
		return
	self_item = info
	if self_item.id > 81:
		self.texture = AllItem.consumable_item_icon_pic_group[1]
		self.set_hframes(3)
		self.set_vframes(4)
		self.set_frame(self_item.id-81-1)
	else:
		self.texture = AllItem.consumable_item_icon_pic_group[0]
		self.set_hframes(9)
		self.set_vframes(9)
		self.set_frame(self_item.id-1)
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
