extends CharacterBody2D

var boxing_pre:bool = false
var input_lock = false
var boxing:int = 0
var switch_walk = false

#角色属性
var hp:float = 300.0
var mp:float = 300.0
var gravity:float = 3000
var jump_level : int = 0
var current_item_id:int = -1
var current_item:item
var player_bag: Array[int] = []###已弃用
var equiped_weapon
var SPEED:float = 500.0          #移速
var toward_right:bool = true     #朝向
#var input_lock:bool =false       #输入锁定
var can_use:bool = true         #使用锁定


@onready  var animationplayer = $AnimationPlayer_hand
@onready  var body = $"骨骼层"


func _ready() -> void:
	animationplayer.play("RESET")


func _physics_process(delta: float) -> void:
	
	#暂时的重力模拟
	if is_on_floor():
		jump_level = 0
	else:
		velocity.y += gravity * delta
	
	var direction2 = Input.get_axis("move_left", "move_right")
	if direction2:
		velocity.x = direction2 * SPEED
		if direction2 < 0:
			toward_right = false
			
		if direction2 > 0:
			toward_right = true
			
		animationplayer.play("主角行走/walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animationplayer.play("RESET")

	
	if toward_right:
		body.scale.x = 1
	else:
		body.scale.x = -1
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:  # 检查按键按下
		if event.keycode == KEY_1:
			$AnimationPlayer_hand.play("技能_一线闪_蓄力")
		for i in range(8):  # 0-7 对应 1-8
			if event.keycode == KEY_1 + i:  # KEY_1 对应数字1，KEY_2对应数字2，依此类推
				break  # 避免重复检测
	
	
	
	if Input.is_action_just_pressed("jump"):
		if boxing_pre:
			$AnimationPlayer_hand.play_backwards("boxing_pre")
		else:
			$AnimationPlayer_hand.play("boxing_pre")
		boxing_pre = !boxing_pre
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			if input_lock:
				return
			if boxing_pre:
				if boxing == 0:
					$AnimationPlayer_hand.play("boxing_punch_1")
					boxing += 1
					input_lock = true
					return
				if boxing == 1:
					$AnimationPlayer_hand.play("boxing_punch_2")
					boxing  = 0
					input_lock = true
					return
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "boxing_pre":
		return
	
	input_lock = false
		
	pass # Replace with function body.
