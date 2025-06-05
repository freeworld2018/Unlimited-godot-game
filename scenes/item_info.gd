extends RigidBody2D

#可以掉落的 捡起来的物品
var self_item:item 
var in_bag:bool = false
var can_pick:bool =true
var tag = [] 

signal picked
#用以控制物体移动
var target:Node2D
var picking:bool
var attraction_force:float = 2000.0

func set_in_bag(value:bool):
	in_bag = value
	self.freeze = in_bag
	self.process_mode =Node.PROCESS_MODE_DISABLED

func set_info(info:item):
	self_item = info
	match self_item.type:
		0:$Sprite2D.texture = load(self_item.pic)
		1:
			$Sprite2D.texture = load(self_item.pic)
			$Sprite2D.set_hframes(16)
			$Sprite2D.set_vframes(8)
			$Sprite2D.set_frame(self_item.picset_id-1)
		2:
			$Sprite2D.texture = load(self_item.pic)
			$Sprite2D.set_hframes(16)
			$Sprite2D.set_vframes(8)
			$Sprite2D.set_frame(self_item.picset_id-1)
			#var a = AtlasTexture.new()
			#a.atlas = load(self_item.pic)
			#$Sprite2D.texture = a
		

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
