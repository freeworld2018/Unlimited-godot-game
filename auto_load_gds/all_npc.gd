extends Node

var npc_group = []

func _ready() -> void:
	var open_json_data = FileAccess.open("res://data/data_npc.json",FileAccess.READ)
	
	var get_json_data = JSON.parse_string(open_json_data.get_as_text())
	
	open_json_data.close()
	
	for i in get_json_data:
		var npc_a = npc.new()
		
		"""
		npc_name : npc名称
		type : npc类型
		pic : npc图片索引
		id : npcId
		box_collide_height : npc碰撞箱高度
		box_collide_width : npc碰撞箱宽度
		sprite_scale : npc精灵图缩放大小
		dialogue : npc对话表索引
		"""
		npc_a.npc_name = i["npc_name"]
		npc_a.type = i["type"]
		npc_a.pic = i["pic"]
		npc_a.id = i["id"]
		npc_a.box_collide_height = i["box_collide_height"]
		npc_a.box_collide_width = i["box_collide_width"]
		npc_a.sprite_scale = i["sprite_scale"]
		npc_a.dialogue = i["dialogue"]
		
		npc_group.append(npc_a)

### 根据id获取用户信息
func npc_info(id: int):
	
	# 检查ID是否在有效范围
	if id < 0 || id >= len(npc_group):
		return []
	else:
		return npc_group[id].clone()

### 根据id获取图标
func get_pic(id: int):
	
	# 检查ID是否在有效范围
	if id < 0 || id >= len(npc_group):
		# 返回空数组
		return []
	else:
		# 返回除id以外的参数
		return [npc_group[id].npc_name, 
		npc_group[id].type, 
		npc_group[id].pic, 
		npc_group[id].box_collide_height, 
		npc_group[id].box_collide_width, 
		npc_group[id].sprite_scale,
		npc_group[id].dialogue]
	
