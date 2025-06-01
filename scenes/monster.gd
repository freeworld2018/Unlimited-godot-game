extends CharacterBody2D


var SPEED:float = 300.0          #移速
var toward_right:bool = true     #朝向

var main



var hp:int


func _ready() -> void:
	main = self.get_parent()
	
	
func _physics_process(delta: float) -> void:
	
	#暂时的重力模拟
	velocity.y = +300.0
	move_and_slide()
	
func _on_pickup_range_body_entered(body: Node2D) -> void:
	print(body.name)
	pass # Replace with function body.
