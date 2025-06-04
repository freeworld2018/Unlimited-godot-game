extends Area2D  # 或 RigidBody2D（如果需要物理）

# 配置参数
@export var speed := 500.0     # 子弹速度
@export var direction := Vector2.RIGHT  # 默认向右发射（可动态修改）
@export var max_distance := 1000.0  # 最大飞行距离后销毁
var dammge:float = 20.0
var travelled_distance:float =  0.0

func _ready():
	# 子弹生成后自动销毁（避免内存泄漏）
	# 如果不需要超时销毁，可以移除下面这行
	$LifetimeTimer.start()  # 添加一个 Timer 节点并命名为 LifetimeTimer

func _physics_process(delta):
	# 移动子弹
	var velocity = direction.normalized() * speed * delta
	position += velocity
	travelled_distance += velocity.length()

	
	# 先检测射线碰撞
	
	$RayCast2D.force_raycast_update()  # 立即更新射线
	
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider.is_in_group("hurtable"):
			collider.take_damage(dammge)
		destroy()
	# 超出最大距离后销毁
	if travelled_distance > max_distance:
		destroy()

# 碰撞检测
func _on_Bullet2D_body_entered(body: Node):
	if body.is_in_group("hurtable"): 
		body.take_damage(dammge)   
	destroy()

# 销毁子弹
func destroy():
	print("子弹销毁")
	queue_free() 

# 超时销毁（通过 Timer 节点）
func _on_LifetimeTimer_timeout():
	destroy()
