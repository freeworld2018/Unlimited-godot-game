extends CharacterBody2D

# TODO name ===============>信 号<===============
#region 信号

#endregion

# TODO name ===============>常 量<===============
#region 常量
@onready var dialog_box
@onready var main = $"../../"
@onready var main_anim:AnimationPlayer = $"../../MainTreeAnim"
@onready var player_sprite: Sprite2D = $"Sprite2D"
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var timer: Timer = $Timer

#endregion

# TODO name ===============>变 量<===============
#region 变量
var gravity = 3000.
var self_npc:npc
var npc_speed = 50.
var target_distance = self.position.x
var direction = -1
var hp: int = 200

var is_enter: bool = false
var is_fleeing: bool = false
var is_move: bool = false

#endregion

# TODO name ===============>虚 方 法<===============
#region 常用的虚方法
# 初始化
func _init() -> void:
	pass

# 开始更新
func _ready() -> void:
	#main = self.get_parent()
	pass

# 帧更新
func _process(delta: float) -> void:
	var xgjl = $"../../player".position - self.position
	#if xgjl.y > 50 or xgjl.x < -50 or xgjl.y > 50 or xgjl.x < -50:
	if !is_enter and $"../../UI_layer/DialogBox".visible == true and $"../../UI_layer/DialogBox/Control/NPCName".text == self_npc.npc_name:
			print("关闭对话框， 节点名称：", self.name)
			main_anim.play("DialogBoxOFF")
			await main_anim.animation_finished
	
	# 移动行为
	if is_move:
		if is_fleeing:
			velocity.x = direction * npc_speed * 3
		else:
			velocity.x = direction * npc_speed
		if direction == -1 and target_distance > self.position.x:
			is_fleeing = false
			is_move = false
			print("超出结算")
			self.position.x == target_distance
			velocity.x = 0
		elif direction == 1 and target_distance < self.position.x:
			is_fleeing = false
			is_move = false
			print("超出结算")
			self.position.x == target_distance
			velocity.x = 0

# 物理帧更新
func _physics_process(delta: float) -> void:
	
	#暂时的重力模拟
	velocity.y += gravity * delta
	
	move_and_slide()

# 监听输入
func _input(event: InputEvent) -> void:
	if is_enter and $"../../UI_layer/DialogBox".visible == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				print("开启对话框， 节点名称：", self.name)
				
				# 修改对话框数据
				$"../../UI_layer/DialogBox/Control/NPCName".text = self_npc.npc_name                  # NPC名称
				$"../../UI_layer/DialogBox/Control/MarginContainer/content".text = "Ha!!!Ha!!!Ha!!!"  # 对话内容
				$"../../UI_layer/DialogBox/Control/HBoxContainer/NPCImg".texture = load(self_npc.pic) # NPC图标
				#$"../DialogBox/HBoxContainer/prompt"                                     # 提示按钮
				#$"../DialogBox/HBoxContainer/Help"                                       # 帮助按钮
				
				main_anim.play("DialogBoxON")
				await main_anim.animation_finished
	
	if ray_cast.is_colliding():
		print("检测到碰撞")

# 监听未处理的输入
func _unhandled_input(event: InputEvent) -> void:
	pass
#endregion

# TODO name ===============>信 号 链 接 方 法<===============
#region 信号链接方法
### 鼠标进入
func _on_area_2d_mouse_entered() -> void:
	player_sprite.material.set_shader_parameter("outline_width",8.0)

### 鼠标移出
func _on_area_2d_mouse_exited() -> void:
	player_sprite.material.set_shader_parameter("outline_width",0.0)

#### 鼠标是否进入npc碰撞箱
#func _on_interaction_mouse_left_mouse_entered() -> void:
	#print("鼠标——进入npc碰撞箱")
	#is_interaction = true
#
#### 鼠标是否移出npc碰撞箱
#func _on_interaction_mouse_left_mouse_exited() -> void:
	#print("鼠标——移出npc碰撞箱")
	#is_interaction = false

### 玩家进入
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("玩家——进入npc碰撞箱")
	player_sprite.material.set_shader_parameter("outline_width",8.0)
	is_enter = true

### 玩家移出
func _on_area_2d_body_exited(body: Node2D) -> void:
	print("玩家——移出npc碰撞箱")
	player_sprite.material.set_shader_parameter("outline_width",0.0)
	is_enter = false

### 计时结束
func _on_timer_timeout() -> void:
	# 逃窜中不执行普通移动
	if is_fleeing:
		return
	
	# 随机时间
	var randam_time = randf_range(8., 16.)
	# 随机距离 and 确定位置
	target_distance = self.position.x + randf_range(-300., 300.)
	# 修改计时器时间
	timer.wait_time = randam_time
	# 启用移动
	is_move = true
	# 清除作用力
	velocity.x = 0
	modify_direction(target_distance)

#endregion

# TODO name ===============>工 具 方 法<===============
#region 工具方法

### 修改信息
func set_info(info: npc):
	self_npc = info
	$CollisionShape2D.scale = Vector2(self_npc.box_collide_width, self_npc.box_collide_height)
	$interaction_mouse_left/CollisionShape2D.scale = $CollisionShape2D.scale
	$Sprite2D.scale = Vector2(self_npc.sprite_scale, self_npc.sprite_scale)
	$Sprite2D.texture = load(self_npc.pic)
	pass

### 获取NpcId
func get_id():
	return self_npc.id

### 受击
func take_damage(value:int,point:Vector2):
	print(self.name+"受到了"+str(value)+"点伤害！")
	fleeing()
	main.hurt_happen.emit(value,point)
	self.hp -= value
	if self.hp <= 0:
		self.die()

### 死亡
func die():
	queue_free()
	# 物品掉落

### 逃窜
func fleeing():
	# 前方碰撞检测
	is_move = true
	is_fleeing = true
	# 随机距离
	var distance = randf_range(300., 500.)
	if $"../../player".position > self.position:
		# 确定位置
		target_distance = self.position.x + (distance * -1)
	else:
		target_distance = self.position.x + distance
	modify_direction(target_distance)

### 确定方向
func modify_direction(target_distance):
	if self.position.x > target_distance:
		direction = -1
		$Sprite2D.scale.x = self_npc.sprite_scale * 1
	else:
		direction = 1
		$Sprite2D.scale.x = self_npc.sprite_scale * -1

#endregion
