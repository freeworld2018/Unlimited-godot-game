extends Node
class_name item
var item_name:String
var type:int
var pic:String
var id:int
var stack:bool = false   #堆叠默认为不可以堆叠
var picset_id:int    #图集索引
var effect:Array[int]


func set_value(value:Array):
	item_name = value[0]
	type = value[1]
	pic  = value[2]
	id  = value[3]
	stack  = value[4]
	
func get_id():
	return id
func info():
	var a = []
	a.append(name)
	a.append(type)
	a.append(pic)
	a.append(id)
	a.append(stack)
	return a
