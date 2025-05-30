extends CharacterBody2D

var SPEED:float = 300.0
var toward_right:bool = true

@onready var up_body = $body
@onready var arm = $arm
@onready var down_body = $AnimatedSprite2D

var hp:int
var mp:int
var bag = []
var equiped_weapon


func _input(event: InputEvent) -> void:
	
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

	var direction2 = Input.get_axis("ui_left", "ui_right")
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

func auto_pickup(item:RigidBody2D):
	#捡起物品
	var tween = get_tree().create_tween()
	tween.tween_method(item.set_position,item.get_position(),self.position,0.3)
	await tween.finished
	bag.append(item.get_id())
	super_print("获得了物品"+item.item_name)
	item.queue_free()
	pass

func super_print(text:String):
	self.get_parent().super_print(text)











func _on_pickup_range_body_entered(body: Node2D) -> void:
	print(body.name)
	auto_pickup(body)
	pass # Replace with function body.
