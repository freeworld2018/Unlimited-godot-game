extends Node2D

var boxing_pre:bool = false
var input_lock = false
var boxing:int = 0
var switch_walk = false





func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		self.position.x -= 1
		self.switch_walk = true
	if Input.is_action_pressed("ui_right"):
		self.position.x += 1
		self.switch_walk = true
	if switch_walk:
		$AnimationPlayer_foot.play("walk")


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
