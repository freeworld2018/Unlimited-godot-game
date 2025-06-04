extends Sprite2D  # 或 RigidBody2D（如果需要物理）

# 配置参数
@export var speed := 1500.0     # 子弹速度
@export var direction := Vector2.RIGHT  # 默认向右发射（可动态修改）
@export var max_distance := 100000.0  # 最大飞行距离后销毁
var running:bool = true
var dammge:float = 20.0
var travelled_distance:float =  0.0
var lifetime:float = 5.0
func _ready():
	$LifetimeTimer.start(lifetime)  # 添加一个 Timer 节点并命名为 LifetimeTimer
	
func _physics_process(delta):
	# 移动子弹
	if not running:
		return
	var velocity = direction.normalized() * speed * delta
	position += velocity
	travelled_distance += velocity.length()
	
	$RayCast2D.force_raycast_update()  # 立即更新射线
	
	if $RayCast2D.is_colliding():
		running = false
		var collision_point = $RayCast2D.get_collision_point()
		var collider = $RayCast2D.get_collider()
		if collider.is_in_group("hurtable") and not collider.is_in_group("主角") :
			collider.take_damage(dammge,collision_point)
		print(collider.name)
		destroy(collision_point)
	# 超出最大距离后销毁
	if travelled_distance > max_distance:
		destroy_no_collsion()

# 碰撞检测
func _on_Bullet2D_body_entered(body: Node):
	if body.is_in_group("hurtable"): 
		body.take_damage(dammge)   
	destroy_no_collsion()

func destroy_no_collsion():
	queue_free() 
	pass
# 销毁子弹
func destroy(collision_point:Vector2):
	
	print("子弹销毁")
	#====================未完成的功能——————指出子弹轨迹=========
	#var bullet_line = Line2D.new()
	#self.add_child(bullet_line)
	#bullet_line.add_point(Vector2(24,0))
	#bullet_line.add_point(Vector2(24,0)- direction*100)
	
	var timer = get_tree().create_timer(2.0)
	await  timer.timeout
	queue_free() 

# 超时销毁（通过 Timer 节点）
func _on_LifetimeTimer_timeout():
	destroy_no_collsion()
