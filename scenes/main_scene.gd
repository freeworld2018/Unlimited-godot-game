extends Node2D
signal hurt_happen(damage:int,damage_point:Vector2)

var test_npc = load("res://scenes/npcTemplate/npc_template.tscn")
var test_item = load("res://scenes/item.tscn")
var icon_item = load("res://scenes/icon_item.tscn")
@onready var damage_number = load("res://scenes/effects/damage_number.tscn")


@onready var inventory = $UI/Inventory
@onready var camera = $Camera2D
var zoom_value_range:int = 1

func _ready():
	
	hurt_happen.connect(_on_hurt_happen)#处理伤害信号
	
	
	SignalBus.invenetory_get_item.emit(AllItem.get_item(0),1)
	SignalBus.invenetory_get_item.emit(AllItem.get_item(27),1)
	SignalBus.invenetory_get_item.emit(AllItem.get_item(1),1)

	create_base_ground()

###用以生成初始基本地形
func create_base_ground():
	var g_group:Array[Texture2D]
	for i in range(5):
		var g_1:Texture2D = load("res://gane_assets/art/front_pic/ground_"+str(i+1)+".png")
		g_group.append(g_1)
	var set_pos_x = 0
	var set_pos_x_left = 0
	for i in range(10):
		#右侧地图生成
		var ground_piece = Sprite2D.new()
		ground_piece.centered = false
		var select_g = g_group[randi()%5]
		ground_piece.texture = select_g
		$ground.add_child(ground_piece)
		ground_piece.position = Vector2(set_pos_x,1200)
		set_pos_x +=select_g.get_width()
		
		#左侧地图生成
		var ground_piece_left = Sprite2D.new()
		ground_piece_left.centered = false
		var select_g_left = g_group[randi()%5]
		ground_piece_left.texture = select_g_left
		$ground.add_child(ground_piece_left)
		set_pos_x_left +=select_g_left.get_width()
		ground_piece_left.position = Vector2(-set_pos_x_left,1200)
		
	$ground/ground/CollisionShape2D.shape.size.x = set_pos_x*2

###镜头控制 camera2d
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("resize_up"):
		if camera.zoom.x <1.8:
			camera.zoom += Vector2(0.2,0.2)
	if Input.is_action_just_pressed("resize_down"):
		if camera.zoom.x >0.8:
			camera.zoom -= Vector2(0.2,0.2)

### 处理命令
func handle_command(text:String):
	# 拆分为数组
	var text_group = text.split(" ")
	# 确保有两条关键数据
	if len(text_group) != 2:
		super_print("错误用法")
		return
	# 获取指令
	var command_1 = text_group[0]
	# 获取类型
	var command_2 = int(text_group[1])
	# 筛选指令
	if command_1 == "quit":
		get_tree().quit()
	if command_1 not in ["spawn","get","kill","createNPC"]:
		super_print("未知指令")
		return
	if typeof(command_2) != 2:
		super_print("错误数据")
		return
	#最终处理
	match text_group[0]:
		"spawn":
			super_print("spawn指令",1)
			if command_2.is_valid_integer():
				create_item_by_id(command_2)
			else:
				create_monster_by_name(command_2)
		"get":super_print("get指令",1)
		"kill":super_print("kill指令",1)
		"createNPC":
			super_print("生成NPC指令", 1)
			create_npc_by_id(command_2, $player.position + Vector2(0, -200))
		
		
### 给予玩家物品(id)
func create_item_by_id(itemid:int):
	
	var test_0 = test_item.instantiate()        ###实例化物品
	test_0.set_info(AllItem.get_item(itemid))  ###从AllItem获取一个序号为itemid的item类 作为参数
	self.add_child(test_0)                   
	test_0.position = Vector2(100,0)
	#print(test_0.self_item.item_name)

### 生成单位
func create_monster_by_name(name:String):
	
	pass
	#var test_0 = test_item.instantiate()
	#test_0.set_info(AllItem.item_info(name))
	#self.add_child(test_0)
	#test_0.position = Vector2(100,0)

### 命令窗回车信号
func _on_line_edit_text_submitted(new_text: String) -> void:
	handle_command(new_text)
	$UI_layer/CommandWindow/LineEdit.clear()
	super_print(new_text)
	pass # Replace with function body.

### 命令响应窗口
func super_print(text:String,color:int = 0):
	var message_color:String
	# 0 = 白色   1 = 红色  2 = 黄色 aaaaaaaaaaaaaa
	match color:
		0:message_color = "white"
		1:message_color = "yellow"
		2:message_color = "red"
	#控制台输出$/CommandWindow
	$UI_layer/CommandWindow/console/RichTextLabel.text += "[color="+message_color+"]"+text+"[/color]"+"\n"


func _on_timer_timeout() -> void:
	#create_item_by_id(27)
	#create_item_by_id(0)
	#create_item_by_id(1)
	pass # Replace with function body.

func _on_hurt_happen(value:int,point:Vector2):
	#处理伤害？   处理伤害数字！
	var damage_num = damage_number.instantiate()
	self.add_child(damage_num)
	damage_num.set_damage_num(value)
	damage_num.position = point
	pass

### 生成NPC
func create_npc_by_id(npcid:int, create_pos: Vector2):
	var npc_0 = test_npc.instantiate()
	npc_0.set_info(AllNpc.npc_info(npcid))
	npc_0.position = create_pos
	$NPCNode.add_child(npc_0)
