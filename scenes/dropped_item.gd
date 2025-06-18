extends RigidBody2D

#可以掉落的 捡起来的物品
var self_item:item 
var in_bag:bool = false
var can_pick:bool =true
var tag = [] 
var quantity:int = 1




#用以控制物体移动
signal picked
var target:Node2D
var picking:bool
var attraction_force:float = 2000.0

func _ready():
	pass


func set_info(info:item):
	var pic1 = $Sprite2D
	
	#1.
	if info.id == -1:
		self_item = info
		pic1.texture = AllItem.weapon_icon_pic_group[0]
		pic1.set_hframes(3)
		pic1.set_vframes(3)
		pic1.set_frame(self_item.type)
		return
	self_item = info
	
	if self_item.id > 81:
		pic1.texture = AllItem.consumable_item_icon_pic_group[1]
		pic1.set_hframes(3)
		pic1.set_vframes(4)
		pic1.set_frame(self_item.id-81-1)
	else:
		pic1.texture = AllItem.consumable_item_icon_pic_group[0]
		pic1.set_hframes(9)
		pic1.set_vframes(9)
		pic1.set_frame(self_item.id-1)
	
			
		

func get_id():
	return self_item.id


func _physics_process(delta):
	if picking and target:
		gravity_scale = 0.0
		apply_attraction_force()

func apply_attraction_force():
	var direction = (target.global_position - global_position).normalized()
	var distance = global_position.distance_to(target.global_position)
	
	# 计算力的大小(距离越近力越小)
	var force_strength = attraction_force

	
	# 应用力
	var force = direction * force_strength
	apply_central_force(force)
	
	# 限制最大速度
	if linear_velocity.length() > 9000.0:
		linear_velocity = linear_velocity.normalized() * 9000.0
	
	if distance < 20.0:
		gravity_scale = 1.0
		picking= false
		picked.emit()

func throw_cold():
	can_pick = false
	var a =get_tree().create_timer(1.0)
	await a.timeout
	can_pick = true
