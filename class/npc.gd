extends Node

class_name npc # 非玩家操控角色
var npc_name: String
var type: int
var pic: String
var id: int
var box_collide_height: float
var box_collide_width: float
var sprite_scale: float
var dialogue: int

### 从获取的数据中获取对应参数
func set_value(value: Array):
	npc_name = value[0]
	type = value[1]
	pic = value[2]
	id = value[3]
	box_collide_height = value[4]
	box_collide_width = value[5]
	sprite_scale = value[6]
	dialogue = value[7]

### 写入玩家数据
func info():
	var a = []
	a.append(npc_name)
	a.append(type)
	a.append(pic)
	a.append(id)
	a.append(box_collide_height)
	a.append(box_collide_width)
	a.append(sprite_scale)
	a.append(dialogue)
	return a

### 避免引用
func clone():
	var a = npc.new()
	a.set_value(self.info())
	return a
