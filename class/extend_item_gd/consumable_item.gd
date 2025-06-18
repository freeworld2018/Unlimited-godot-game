extends item
class_name consumablue_item
#消耗品
var value:int
var effect:Array = []
var stack:bool = true


func set_value(value:Array):
	self.item_name= value[0]
	self.type = value[1]
	self.icon_pic  = value[2]
	self.id  = value[3]
	self.value = value[4]
	self.effect = value[5].duplicate()

func get_value():
	var a = []
	a.append(self.item_name)
	a.append(self.type)
	a.append(self.icon_pic)
	a.append(self.id)
	a.append(self.value)
	a.append(self.effect)
	return a
func clone():
	var a = consumablue_item.new()
	a.set_value(self.get_value())
	return a
