extends Node
class_name item  # 物品/掉落物
var item_name:String
var type:int
var icon_pic:String
var id:int




func set_value(value:Array):
	item_name = value[0]
	type = value[1]
	icon_pic  = value[2]
	id  = value[3]

func get_id():
	return id
func info():
	var a = []
	a.append(item_name)
	a.append(type)
	a.append(id)

	return a
func clone():#避免引用
	var a =item.new()
	a.set_value(self.info())
	return a
