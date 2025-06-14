extends Node


func create_a_weapon(power_level:int):
	#用力量等级生成一把武器， 
	var new_weapon = weapon.new()
	var random_num = randi()%100
	new_weapon.type = randi()%8
	new_weapon.material = randi()%4
	if power_level > 50:
		new_weapon.material = randi()%11
	var  weight_factor:int = weapon.material_weight_factor[new_weapon.material]
	var  volume_factor:int = weapon.type_volume_factor[new_weapon.type]
	new_weapon.weight = weight_factor * volume_factor
	#武器加权强度
	var mulit_power_factor = weapon.material_atk_power_factor[new_weapon.material]+ \
	weapon.material_atk_power_factor[new_weapon.type]
	new_weapon.attack_power=mulit_power_factor + power_level/10 
	match new_weapon.type:
		weapon.MaterialType.铁:
			new_weapon.desp.append("它是由铁制成的。")
			new_weapon.good_desp.append("它是坚硬的。")
			new_weapon.bad_desp.append("它会改变持有者附近闪电的轨迹。")
			pass
		weapon.MaterialType.橡木:
			new_weapon.desp.append("它是由橡木制成的。")
			new_weapon.bad_desp.append("它会被火焰点燃。")
			new_weapon.good_desp.append("它是坚硬的。")
		weapon.MaterialType.松木:
			new_weapon.desp.append("它是由松木制成的。")
			new_weapon.bad_desp.append("它会被火焰点燃。")
			new_weapon.good_desp.append("它是坚硬的。")
