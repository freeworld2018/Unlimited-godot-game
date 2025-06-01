extends Node
class_name entity # 实体
var desc_name:String
var type:int
var pic:String
var id:int
var stack:int



func set_value(value:Array):
	desc_name = value[0]
	type = value[1]
	pic  = value[2]
	id  = value[3]
	stack  = value[4]
	
func get_id():
	return id
func info():
	var a = []
	a.append(desc_name)
	a.append(type)
	a.append(pic)
	a.append(id)
	a.append(stack)
	return a
