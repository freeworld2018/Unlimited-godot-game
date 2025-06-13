extends Node2D
@onready var  player_animationplayer = $"../../AnimationPlayer_hand"
@onready var player = $"../.."

var full_charge_time:float = 2.0
var damage:float = 20
var dash_distance_float = 100

func _ready() -> void:
	SignalBus.player_start_charge.connect(_on_start_charge)
	SignalBus.player_release_charge.connect(_on_charge_release)
	
	
func _on_start_charge():
	player_animationplayer.play("技能_一线闪_蓄力")
func _on_charge_release(time:float):
	if time > full_charge_time:
		player_animationplayer.play("技能_一线闪_发射")
		var tween = get_tree().create_tween()
		#使用bool值转换来确定位移方向
		tween.tween_method(player.set_position,player.position,player.position+Vector2((2*int(player.toward_right)-1)*200,0),0.1)
		await  player_animationplayer.animation_finished
		SignalBus.player_skill_end.emit()
	else:
		player_animationplayer.play_backwards("技能_一线闪_蓄力")
		await  player_animationplayer.animation_finished
		SignalBus.player_skill_end.emit()
	pass
func start_charge():
	pass

func release():
	pass
