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

func set_in_bag(value:bool):
	pass

func set_info(info:item):
	self_item = info.clone()
	var pic1 = $Sprite2D
	match self_item.type:
		0:pic1.texture = load(self_item.pic)
		1:
			pic1.texture = load(self_item.pic)
			pic1.set_hframes(16)
			pic1.set_vframes(8)
			pic1.set_frame(self_item.picset_id-1)
		2:
			pic1.texture = load(self_item.pic)
			pic1.set_hframes(16)
			pic1.set_vframes(8)
			pic1.set_frame(self_item.picset_id-1)
		3:
			pic1.texture = load(self_item.pic)
			
		

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
