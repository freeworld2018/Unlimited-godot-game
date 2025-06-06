extends CharacterBody2D






#获得节点(子节点）
@onready var up_body = $body
@onready var arm = $arm
@onready var down_body = $AnimatedSprite2D


#获得节点(非子节点）
@onready var main = self.get_parent()
@onready var inventory = $"../UI/Inventory"
@onready var current_item_point_pic = $arm/item_point/Sprite2D
@onready var item_bar = $"../UI/item_bar"
@onready var hand =$"../UI/hand"

#角色属性
var hp:float = 300.0
var mp:float = 300.0
var gravity:float = 3000
var jump_level : int = 0
var current_item_id:int = -1
var current_item:item
var player_bag: Array[int] = []###已弃用
var equiped_weapon
var SPEED:float = 500.0          #移速
var toward_right:bool = true     #朝向
var input_lock:bool =false       #输入锁定
var can_use:bool = true         #使用锁定

###危险的值 武器偏转,这个值用来实现武器的偏转，请勿设定、更改、删除它。
var weapon_offset:float = 0

func _ready() -> void:
	player_bag.resize(8)  # 调整大小为 64
	player_bag.fill(-1)     # 填充默认值 0
	main = self.get_parent()
	
	

func _input(event: InputEvent) -> void:
	#对于鼠标点击的响应
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			if inventory.switch_mouse_in:
				return
			if current_item_id != -1 and  can_use:
				can_use = false
				use_item(current_item_id)
			pass
		if event.button_index == MOUSE_BUTTON_RIGHT :
			if inventory.switch_mouse_in:
				return
			if hand.is_null():
				return
			throw_item(current_item_id)
			
	elif event.is_action("jump"):
		if jump_level < 2:
			velocity.y = -800.0
			jump_level += 1
		pass

func _process(delta: float) -> void:
	#var mouse_pos = get_global_mouse_position()
	#var direction = mouse_pos - global_position  # 获取方向向量
	#arm.rotation = rad_to_deg().angle()  # 计算方向向量的角度并赋值给节点
	return
	arm.look_at(get_global_mouse_position())
	arm.rotate(deg_to_rad(-90))
	#print(direction.angle())
	
	
			
	pass
	
func _physics_process(delta: float) -> void:
	
	#暂时的重力模拟
	if is_on_floor():
		jump_level = 0
	else:
		velocity.y += gravity * delta
	
	var direction2 = Input.get_axis("move_left", "move_right")
	if direction2:
		velocity.x = direction2 * SPEED
		if direction2 < 0:
			toward_right = false
			
		if direction2 > 0:
			toward_right = true
		$AnimatedSprite2D.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("idle")
	down_body.flip_h = !toward_right
	up_body.flip_h = !toward_right
	arm.flip_h = !toward_right
	current_item_point_pic.flip_v = !toward_right
	
	if toward_right:
		#对手臂的偏转修复
		arm.position = Vector2(-10,-30)
		arm.offset = Vector2(10,30)
		current_item_point_pic.position.x = weapon_offset
	else:
		arm.position = Vector2(10,-30)
		arm.offset = Vector2(-10,30)
		current_item_point_pic.position.x = 0
		
		
			
		
		
		
		
	move_and_slide()

################核心功能####################
func use_item(itemid:int):
	match current_item.type:
		0:
			shoot_animate()
		1:
			eat_animate()
			
		2:
			eat_animate()
		3:
			attack_animate()
	pass

func eat_animate():
	var tween = get_tree().create_tween()
	if toward_right:
		#自定义函数可以对 左右吃东西移动进行修正，
		tween.tween_method(arm.set_rotation_degrees,0,-120.0,0.2)
	else:
		tween.tween_method(arm.set_rotation_degrees,0,120.0,0.2)
	await tween.finished
	arm.set_rotation_degrees(0)
	can_use = true
	current_item_id =-1
	current_item_point_pic.texture = null
	if not hand.is_null():
		print("吃掉了手上的东西！")
		hand.hand_item.add(-1)
		if hand.hand_item.number ==0:
			hand.del_item()
			set_current_item(item_bar.item_bar_group_id[item_bar.item_bar_select_count])
			return
		set_current_item(hand.hand_item.get_id())
		return
	inventory.del_item(item_bar.item_bar_select_count)
	set_current_item(item_bar.item_bar_group_id[item_bar.item_bar_select_count])
	pass
func shoot_animate():
	arm.look_at(get_global_mouse_position())
	arm.rotate(deg_to_rad(-90))
	var time_cold = get_tree().create_timer(1.0)
	var a = load("res://scenes/Projectile/bullet.tscn")
	var b = a.instantiate()
	self.add_child(b)
	b.top_level = true
	b.position  = $arm/item_point.global_position
	b.direction = get_global_mouse_position()-$arm/item_point.global_position
	b.look_at(get_global_mouse_position())
	await  time_cold.timeout
	arm.set_rotation_degrees(0)
	can_use = true
	pass
func attack_animate():
	var tween = get_tree().create_tween()
	if toward_right:
		#自定义函数可以对 左右吃东西移动进行修正，
		tween.tween_method(arm.set_rotation_degrees,-120,60.0,0.4)
	else:
		tween.tween_method(arm.set_rotation_degrees,120,-60.0,0.4)
	await tween.finished
	arm.set_rotation_degrees(0)
	can_use = true
	pass
func throw_item(itemid:int):
	var test_0 = main.test_item.instantiate()
	test_0.set_info(current_item.clone())
	main.add_child(test_0)
	test_0.position = self.position
	test_0.throw_cold()
	#print(test_0.self_item.item_name)s
	hand.hand_item.add(-1)
	if hand.hand_item.number ==0:
		hand.del_item()
		return






#受击处理
func take_damage(value:int,point:Vector2):
	print(self.name+"受到了"+str(value)+"点伤害！")
	self.hp -= value
	if self.hp <= 0:
		self.die()
#死亡
func die():
	#播放死亡动画等等。
	pass



#自动捡起物品
func auto_pickup(pick_item:RigidBody2D):
	#捡起物品
	pick_item.can_pick = false
	pick_item.target = self
	pick_item.picking= true
	await pick_item.picked
	if inventory.item_emptyslots == 0:
		return
	inventory_add_item(pick_item.get_id())###弃用预备
	super_print("获得了物品"+pick_item.self_item.item_name)
	print("获得了物品"+pick_item.self_item.item_name)
	pick_item.queue_free()
	pass

###  调用场景内的方法 super_print(控制台打印）  inventory_set_get(物品栏操作)
func super_print(text:String):
	main.super_print(text)
func inventory_add_item(itemid:int):
	main.inventory_add_item(itemid)

#设置手上的物品
func set_current_item(itemid:int): 
	#被item_bar引用调用 
	#设置当前物品（提供id）
	print("current_item_seted   "+str(itemid))
	current_item_id =itemid
	current_item = AllItem.item_info(itemid)
	if current_item_id == -1:
		current_item_point_pic.texture = null
		return
	current_item_point_pic.position.x = 0
	match current_item.type:
		0:current_item_point_pic.texture = load(current_item.pic) #枪械
		1:#食品
			current_item_point_pic.texture = load(current_item.pic)
			current_item_point_pic.set_hframes(16)
			current_item_point_pic.set_vframes(8)
			current_item_point_pic.set_frame(current_item.picset_id-1)
		2:#水
			current_item_point_pic.texture = load(current_item.pic)
			current_item_point_pic.set_hframes(16)
			current_item_point_pic.set_vframes(8)
			current_item_point_pic.set_frame(current_item.picset_id-1)
		3:#近战
			var image = Image.load_from_file(current_item.pic)
			# 旋转90度（顺时针）
			image.rotate_90(COUNTERCLOCKWISE)  # 或者使用ROTATE_90_COUNTERCLOCKWISE逆时针\
			# 创建新纹理
			var rotated_texture = ImageTexture.create_from_image(image)
			# 应用到Sprite2D
			current_item_point_pic.texture = rotated_texture
			current_item_point_pic.position.x = image.get_height()
			weapon_offset = image.get_height()
			current_item_point_pic.centered = false	
func set_mask(value:bool):
	#设置玩家的pickup_range
	$pickup_range.set_collision_mask_value(2,value)
func _on_pickup_range_body_entered(body: Node2D) -> void:
	#print(body.name)
	if body is RigidBody2D:
		if body.can_pick:
			auto_pickup(body)
	pass # Replace with function body.
