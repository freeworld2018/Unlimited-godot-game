extends CharacterBody2D


var SPEED:float = 300.0          #移速
var toward_right:bool = true     #朝向
var input_lock:bool =false       #输入锁定



#获得节点
@onready var up_body = $body
@onready var arm = $arm
@onready var down_body = $AnimatedSprite2D
@onready var main = self.get_parent()



var hp:int
var mp:int

var current_item

var player_bag: Array[int] = []
var equiped_weapon
func _ready() -> void:
	player_bag.resize(8)  # 调整大小为 64
	player_bag.fill(-1)     # 填充默认值 0


func _input(event: InputEvent) -> void:
	#对于鼠标点击的响应
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			pass

func _process(delta: float) -> void:
	#var mouse_pos = get_global_mouse_position()
	#var direction = mouse_pos - global_position  # 获取方向向量
	#arm.rotation = rad_to_deg().angle()  # 计算方向向量的角度并赋值给节点
	arm.look_at(get_global_mouse_position())
	arm.rotate(deg_to_rad(-90))
	#print(direction.angle())
	pass
	
func _physics_process(delta: float) -> void:
	
	#暂时的重力模拟
	velocity.y = +300.0
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
	if toward_right:
		arm.position = Vector2(-10,-30)
		arm.offset = Vector2(10,30)
	else:
		arm.position = Vector2(10,-30)
		arm.offset = Vector2(-10,30)
	move_and_slide()

func auto_pickup(pick_item:RigidBody2D):
	#捡起物品
	var tween = get_tree().create_tween()
	tween.tween_method(pick_item.set_position,pick_item.get_position(),self.position,0.3)
	await tween.finished
	#向player_bag 以及物品栏中添加
	inventory_add_item(pick_item.get_id())
	super_print("获得了物品"+pick_item.self_item.item_name)
	pick_item.queue_free()
	pass

###  调用场景内的方法 super_print(控制台打印）  inventory_set_get(物品栏操作)

func super_print(text:String):
	main.super_print(text)



func inventory_add_item(itemid:int):
	main.inventory_add_item(itemid)






func _on_pickup_range_body_entered(body: Node2D) -> void:
	print(body.name)
	auto_pickup(body)
	pass # Replace with function body.
