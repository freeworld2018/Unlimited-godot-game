extends CharacterBody2D


var SPEED:float = 500.0          #移速
var toward_right:bool = true     #朝向
var input_lock:bool =false       #输入锁定



#获得节点(子节点）
@onready var up_body = $body
@onready var arm = $arm
@onready var down_body = $AnimatedSprite2D


#获得节点(非子节点）
@onready var main = self.get_parent()
@onready var inventory = $"../UI/Inventory"
@onready var current_item_point_pic = $arm/item_point/Sprite2D
@onready var item_bar = $"../UI/item_bar"


#角色属性
var hp:int
var mp:int
var gravity = 3000

var jump_level : int = 0


var current_item_id:int = -1
var player_bag: Array[int] = []###已弃用
var equiped_weapon
func _ready() -> void:
	player_bag.resize(8)  # 调整大小为 64
	player_bag.fill(-1)     # 填充默认值 0
	main = self.get_parent()
	
	

func _input(event: InputEvent) -> void:
	#对于鼠标点击的响应
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			if current_item_id != -1:
				use_item(current_item_id)
			pass
			
			
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
		arm.position = Vector2(-10,-30)
		arm.offset = Vector2(10,30)
	else:
		arm.position = Vector2(10,-30)
		arm.offset = Vector2(-10,30)
	move_and_slide()

################核心功能####################
func use_item(itemid:int):
	var a = AllItem.item_info(itemid)
	match a.type:
		0:pass
		1:
			eat_animate()
			
		2:
			eat_animate()
			
	pass

func eat_animate():
	var tween = get_tree().create_tween()
	if toward_right:
		tween.tween_method(arm.set_rotation_degrees,0,-120.0,0.2)
	else:
		tween.tween_method(arm.set_rotation_degrees,0,120.0,0.2)
	await tween.finished
	arm.set_rotation_degrees(0)
	item_bar.del_item()
	pass












func auto_pickup(pick_item:RigidBody2D):
	#捡起物品
	if not pick_item.can_pick:
		return 
	pick_item.can_pick = false
	pick_item.target = self
	pick_item.picking= true
	await pick_item.picked
	if inventory.item_emptyslots == 0:
		return
	inventory_add_item(pick_item.get_id())###已弃用aadd
	super_print("获得了物品"+pick_item.self_item.item_name)
	print("获得了物品"+pick_item.self_item.item_name)
	pick_item.queue_free()
	pass

###  调用场景内的方法 super_print(控制台打印）  inventory_set_get(物品栏操作)

func super_print(text:String):
	main.super_print(text)



func inventory_add_item(itemid:int):
	main.inventory_add_item(itemid)



func set_current_item(value:int): #设置当前物品（提供id）
	current_item_id =value
	if current_item_id == -1:
		current_item_point_pic.texture = null
		return
	var a =AllItem.get_pic(value)
	current_item_point_pic .texture = load(a[0])
	if a[1] == 0:
		current_item_point_pic .set_hframes(1)
		current_item_point_pic .set_vframes(1)
		current_item_point_pic .set_frame(0)
	if a[1] != 0:
		current_item_point_pic .set_hframes(16)
		current_item_point_pic .set_vframes(8)
		current_item_point_pic .set_frame(a[1]-1)
func set_mask(value:bool):
	$pickup_range.set_collision_mask_value(2,value)
func _on_pickup_range_body_entered(body: Node2D) -> void:
	#print(body.name)
	if body is RigidBody2D:
		auto_pickup(body)
	pass # Replace with function body.
