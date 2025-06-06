extends RayCast2D
@onready var player = $"../../.."
var damage:int = 10
var hit_group =[]
func _physics_process(delta: float) -> void:
	if player.can_use:
		return
	self.force_raycast_update()  # 立即更新射线
	if self.is_colliding():
		var collision_point = self.get_collision_point()
		var collider = self.get_collider()
		if collider.is_in_group("hurtable") and not collider.is_in_group("主角") :
			if not hit_group.has(collider):
				#print("")
				collider.take_damage(damage,collision_point)
				hit_group.append(collider)
		if not collider.is_in_group("hurtable"):
			print("撞击地面")
