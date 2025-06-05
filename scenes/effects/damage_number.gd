extends Node2D
var damage_num:int = 0
var damage_type:int = 0
func _ready() -> void:
	$Timer.start(2.0)
	var tween = get_tree().create_tween()
	tween.tween_method($Label.set_position,$Label.position,Vector2($Label.position.x,$Label.position.y-50),0.8)
	var tween_twinkle =get_tree().create_tween()
	tween_twinkle.tween_method(Twinkle,0,6,0.5).set_delay(1.5)
func set_damage_num(value:int):
	damage_num = value
	$Label.text = str(damage_num)

func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.

func Twinkle(long:int):
	#print(str(long/2))
	if long%2  == 0:
		$Label.modulate=Color(0.33, 1, 1, 1)
	else:
		$Label.modulate=Color(1, 1, 1, 1)
