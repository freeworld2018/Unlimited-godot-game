extends Sprite2D  # 或 RigidBody2D（如果需要物理）

# 配置参数
@export var speed := 1500.0     # 子弹速度
@export var direction := Vector2.RIGHT  # 默认向右发射（可动态修改）
@export var max_distance := 20000.0  # 最大飞行距离后销毁
var running:bool = true
var damage:float = 20.0
var travelled_distance:float =  0.0
var lifetime:float = 5.0
var line_count:int = 0
var hit_group = []
func _ready():
	$LifetimeTimer.start(lifetime)  # 添加一个 Timer 节点并命名为 LifetimeTimer
	
func _physics_process(delta):
	# 移动子弹
	if not running:
		return
	var velocity = direction.normalized() * speed * delta
	position += velocity
	travelled_distance += velocity.length()
	if (travelled_distance - 100)>line_count*100:
		$bullet_line.add_point(self.position)
		
	$RayCast2D.force_raycast_update()  # 立即更新射线
	if $RayCast2D.is_colliding():
		var collision_point = $RayCast2D.get_collision_point()
		var collider = $RayCast2D.get_collider()
		if collider.is_in_group("hurtable") and not collider.is_in_group("主角") :
			if not hit_group.has(collider):
				collider.take_damage(damage,collision_point)
		if not collider.is_in_group("hurtable"):
			running =false
			print("撞击地面损毁")
			destroy_no_collsion()
		destroy(collision_point)
	# 超出最大距离后销毁
	if travelled_distance > max_distance:
		print("子弹超距销毁")
		destroy_no_collsion()
func destroy_no_collsion():
	queue_free() 
	pass
# 销毁子弹
func destroy(collision_point:Vector2):
	
	var timer = get_tree().create_timer(2.0)
	await  timer.timeout
	print("子弹碰撞后超时销毁")
	queue_free() 

# 超时销毁（通过 Timer 节点）
func _on_LifetimeTimer_timeout():
	print("子弹超时销毁")
	destroy_no_collsion()


func _on_lifetime_timer_timeout() -> void:
	pass # Replace with function body.
