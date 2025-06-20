extends Node
############统一对所有物品进行管理################
##############################################

var weapon_pic_group = []
var weapon_icon_pic_group = []
# 武器生成id管理器
var weapon_create_id:int = 1000



var consumable_item_group = []
var consumable_item_icon_pic_group= []


var null_item:item

func _ready() -> void:
	weapon_icon_pic_group.append(load("res://gane_assets/art/weapon/test_weapon/weapon.png"))
	consumable_item_icon_pic_group.append(load("res://gane_assets/art/consumable_item/food.png"))
	consumable_item_icon_pic_group.append(load("res://gane_assets/art/consumable_item/water.png"))
	weapon_pic_group.append(load("res://gane_assets/art/weapon/test_weapon/长剑.png"))
	weapon_pic_group.append(load("res://gane_assets/art/weapon/test_weapon/法杖.png"))
	weapon_pic_group.append(load("res://gane_assets/art/weapon/test_weapon/长刀.png"))
	weapon_pic_group.append(load("res://gane_assets/art/weapon/test_weapon/细剑.png"))
	weapon_pic_group.append(load("res://gane_assets/art/weapon/test_weapon/短剑.png"))
	weapon_pic_group.append(load("res://gane_assets/art/weapon/test_weapon/短刀.png"))
	weapon_pic_group.append(load("res://gane_assets/art/weapon/test_weapon/匕首.png"))
	weapon_pic_group.append(load("res://gane_assets/art/weapon/test_weapon/魔杖.png"))
	load_consumable_item()
	return

	
#region  物品类加载
func load_weapon_item():
	pass
func load_equipment_item():
	pass
func load_consumable_item():
	#item_name	type	icon_pic	id	value	effect

	var a = FileAccess.open("res://data/data_Consumable_item.json",FileAccess.READ)
	var c = JSON.parse_string(a.get_as_text())
	a.close()
	#var id_count:int = 0
	for i in c:
		var item_a = consumablue_item.new()
		item_a.item_name = i["item_name"]
		item_a.type = i["type"]
		item_a.icon_pic = i["icon_pic"]
		item_a.id = i["id"]
		item_a.stack = i["value"]
		item_a.effect = []
		consumable_item_group.append(item_a)
	pass
func load_material_item():
	pass
func load_furniture_item():
	pass
#endregion

#region  武器类部分
#武器生成  create_weapon   依据强度掉落物品，会按照输入强度来生成一个物品。
#武器生成2 create_weapon(Array) 按照给定的数据产生物品。

func create_weapon_by_power_level(power_level:int,type:int = -1):
	#用力量等级生成一把武器， 
	var new_weapon = weapon.new()
	new_weapon.level = power_level
	var random_num = randi()%100
	if type == -1:
		new_weapon.type = randi()%8
	else:
		new_weapon.type = type
	new_weapon.material = randi()%4
	if randi()%2>0:
		new_weapon.material = randi()%8
	if randi()%2>0:
		new_weapon.material = randi()%11
	var  weight_factor:int = weapon.material_weight_factor[new_weapon.material]
	var  volume_factor:int = weapon.type_volume_factor[new_weapon.type]
	new_weapon.weight = weight_factor * volume_factor
	#武器加权强度
	var mulit_power_factor = weapon.material_atk_power_factor[new_weapon.material]+ \
	weapon.material_atk_power_factor[new_weapon.type]
	new_weapon.attack_power=mulit_power_factor + power_level/10 
	#武器描述添加
	
	#弥补值确定
	var gap_value = power_level - mulit_power_factor + new_weapon.weight
	new_weapon.item_name = weapon.WeaponType_group[new_weapon.type]
	new_weapon.icon_pic = "0"
	new_weapon.pic = weapon_pic_group[new_weapon.type]
	weapon_create_id += 1
	new_weapon.id = weapon_create_id
	new_weapon.type += 5
	return new_weapon
func create_weapon_by_data(data:Array):
	var new_weapon = weapon.new()
	new_weapon.set_value(data)
	return new_weapon

func auto_add_info(new_weapon:weapon):
	#用于自动添加材料的相关描述和确定图片
	
	
	
	new_weapon.desp.append("它是由"+weapon.MaterialTypes_group[new_weapon.type]+"制作的"+\
	weapon.WeaponType_group[new_weapon.material])
	if  new_weapon.material <5:
		new_weapon.good_desp.append("它是坚硬的")
	if  new_weapon.material ==5 or new_weapon.material == 8:
		new_weapon.bad_desp.append("它是脆弱的")
	if new_weapon.material == 0 or new_weapon.material == 3 or new_weapon.material == 10:
		new_weapon.good_desp.append("它让持有者周围的闪电改变轨迹")
	if new_weapon.material == 9 or new_weapon.material == 10:
		new_weapon.good_desp.append("它美观且昂贵")
	pass
#endregion



#region 消耗品部分

func get_item(id:int):
	#通过id寻找物品
	if id < 0 or  id>=len(consumable_item_group):
		return consumable_item_group[0].clone()
	else:
		return consumable_item_group[id].clone()
		
func get_null_item():
	#返回一个空物体，方便对空手等进行操作
	return null_item

func get_pic(id:int):
	if id < 0 or  id>=len(consumable_item_group):
		return [consumable_item_group[0].pic,0]
	else:
		if consumable_item_group[id].type != 0:
			return [consumable_item_group[id].pic,consumable_item_group[id].picset_id]
		return [consumable_item_group[id].pic,0]




#endregion
