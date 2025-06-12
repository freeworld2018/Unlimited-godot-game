extends CharacterBody2D

var boxing_pre:bool = false
var input_lock = false
var boxing:int = 0
var switch_walk = false
var gravity:float = 3000
var jump_level : int = 0
var current_item_id:int = -1
var current_item:item
var toward_right:bool = true     #朝向




#region 角色的所有属性
#角色属性
var player_name:String ="未设定的姓名"
var nick_name:String = "快速的老二"
var level:int = 1			#认定等级
var battle_level:int = 10    #战斗等级
var hunger: float = 100.0    # 饥饿度
var thirst: float = 100.0    # 口渴度
var temperature: float = 37.0 # 体温
var fatigue: float = 0.0     # 疲劳度

var HP:float = 100.0
var MP:float = 100.0
var SPEED:float = 200.0          #移速
var HPS:float = 1.0         #每秒生命回复
var MPS:float = 1.0         #每秒法力回复


var STR:int = 1      # 力量 (Strength)
var AGI:int = 1      # 敏捷 (Agility)
var INT:int = 1      # 智力 (Intelligence)
var WIL:int = 1      # 意志 (Willpower)
var CON:int = 1      # 体质 (Constitution)
var CHA:int = 1      # 魅力 (Charisma)
var KNW:int = 1      # 知识 (Knowledge)
var MAG:int = 1      # 魔力 (Magic/Mana Power)

var stats_growth:Dictionary = {
	"STR": 0,  # 力量
	"AGI": 0,  # 敏捷
	"INT": 0,  # 智力
	"WIL": 0,  # 意志
	"CON": 0,  # 体质
	"CHA": 0,  # 魅力
	"KNW": 0,  # 知识
	"MAG": 0   # 魔力
}
#endregion
#region 状态机
enum CharacterState {
	IDLE,           # 闲置状态
	WALKING,        # 行走
	RUNNING,        # 奔跑
	JUMPING,        # 跳跃中
	FALLING,        # 下落中
	ATTACKING,      # 攻击中
	DEFENDING,      # 防御/格挡
	DYING,          # 死亡过程
	DEAD,           # 死亡状态
	USING_SKILL,    # 使用技能
	STUNNED,        # 眩晕状态
	CHARGING,       # 蓄力状态
	RELEASING       # 释放状态
}
var current_state = CharacterState.IDLE
var previous_state:int

var charge_time:float = 0


#endregion
#var input_lock:bool =false       #输入锁定
var can_use:bool = true         #使用锁定


@onready  var animationplayer = $AnimationPlayer_hand
@onready  var body = $"骨骼层"

func _ready() -> void:
	
	animationplayer.play("RESET")
	SignalBus.player_skill_end.connect(_on_skill_end)

func _on_skill_end():
	change_state(CharacterState.IDLE)

func enter_state(new_state:int):
	match new_state:
		CharacterState.IDLE:
			animationplayer.play("RESET")
			pass
		CharacterState.WALKING:
			animationplayer.play("主角行走/walk")
			pass
		CharacterState.ATTACKING:
			pass
		CharacterState.USING_SKILL:
			pass
		CharacterState.CHARGING:
			SignalBus.player_start_charge.emit()
		CharacterState.RELEASING:
			SignalBus.player_release_charge.emit(charge_time)
func exit_state(state:int):
	
	
	pass
func change_state(new_state:int):
	if new_state == current_state:
		return
	exit_state(current_state)
	
	previous_state = current_state
	current_state = new_state
	
	enter_state(current_state)


func update_state(delta:float):
	match current_state:
		CharacterState.IDLE:
			update_idle(delta)
			pass
		CharacterState.WALKING:
			update_walking(delta)
			pass
		CharacterState.ATTACKING:
			pass
		CharacterState.USING_SKILL:
			pass
		CharacterState.CHARGING:
			update_charging(delta)
			pass
		CharacterState.RELEASING:
			pass
		
	pass

func update_idle(delta:float):
	
	var direction2 = Input.get_axis("move_left", "move_right")
	if direction2:
		velocity.x = direction2 * SPEED
		if direction2 < 0:
			toward_right = false
			
		if direction2 > 0:
			toward_right = true
		change_state(CharacterState.WALKING)
	if toward_right:
		body.scale.x = 1
	else:
		body.scale.x = -1
	
	
func update_walking(delta:float):
	var direction2 = Input.get_axis("move_left", "move_right")
	if direction2:
		velocity.x = direction2 * SPEED
		if direction2 < 0:
			toward_right = false
		
		if direction2 > 0:
			toward_right = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		change_state(CharacterState.IDLE)
	if toward_right:
		body.scale.x = 1
	else:
		body.scale.x = -1
	
	
func update_charging(delta:float):
	charge_time += delta
	pass
	
	
	
	
	
	
	
	
	
	

func _physics_process(delta: float) -> void:
	
	update_state(delta)
	if is_on_floor():
		jump_level = 0
	else:
		velocity.y += gravity * delta
	move_and_slide()
	return
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
			if current_state == CharacterState.IDLE or current_state == CharacterState.WALKING:
				change_state(CharacterState.CHARGING)
		for i in range(8):  # 0-7 对应 1-8
			if event.keycode == KEY_1 + i:  # KEY_1 对应数字1，KEY_2对应数字2，依此类推
				break  # 避免重复检测
	if event is InputEventKey and not event.pressed:
		if event.keycode == KEY_1:
			if current_state == CharacterState.CHARGING:
				change_state(CharacterState.RELEASING)
	
	return
	if event is InputEventMouseButton and event.pressed:
		if boxing_pre:
			pass
		else:
			$AnimationPlayer_hand.play("boxing_pre")
			boxing_pre = true
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
	if anim_name.find("技能"):
		pass
	
	
	
	if anim_name == "boxing_pre":
		return
	
	input_lock = false
		
	pass # Replace with function body.
