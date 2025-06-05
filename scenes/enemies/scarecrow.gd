extends CharacterBody2D


var SPEED:float = 300.0          #移速
var toward_right:bool = true     #朝向

@onready var main = $".."
var hp:int = 20000


func _ready() -> void:
	main = self.get_parent()
	
#受击处理
func take_damage(value:int,point:Vector2):
	print(self.name+"受到了"+str(value)+"点伤害！")
	main.hurt_happen.emit(value,point)
	self.hp -= value
	if self.hp <= 0:
		self.die()
#死亡
func die():
	#播放死亡动画等等。
	pass

func _physics_process(delta: float) -> void:
	#暂时的重力模拟
	velocity.y = +300.0
	move_and_slide()
	
