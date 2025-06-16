extends Node


func create_a_weapon(power_level:int):
	#用力量等级生成一把武器， 
	var new_weapon = weapon.new()
	var random_num = randi()%100
	new_weapon.type = randi()%8
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
	new_weapon.desp.append("它是由"+weapon.MaterialTypes_group[new_weapon.type]+"制作的"+\
	weapon.WeaponType_group[new_weapon.material])
	if  new_weapon.material <5:
		new_weapon.good_desp.append("它是坚硬的")
	if  new_weapon.material ==5 or new_weapon.material == 8:
		new_weapon.bad_desp.append("它是脆弱的")
	var gap_value = power_level - mulit_power_factor + new_weapon.weight
