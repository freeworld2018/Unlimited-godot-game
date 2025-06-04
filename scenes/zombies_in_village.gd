extends Node2D
@onready var test_item = load("res://scenes/item.tscn")
@onready var icon_item = load("res://scenes/icon_item.tscn")
@onready var inventory = $UI/Inventory
@onready var camera = $player/Camera2D
var zoom_value_range:int = 1

func _ready():
	inventory.connect("item_bar_change", $UI/item_bar._on_item_bar_change)
	self.inventory_add_item(0)


###镜头控制 camera2d

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("resize_up"):
		if camera.zoom.x <1.8:
			camera.zoom += Vector2(0.2,0.2)
	if Input.is_action_just_pressed("resize_down"):
		if camera.zoom.x >0.8:
			camera.zoom -= Vector2(0.2,0.2)





###引用物品栏添加物品功能
func inventory_add_item(itemid:int,id:int = -1):
	inventory.add_item(itemid,id)
	pass
func inventory_delete_item(id:int):
	inventory.del_item(id)
	pass

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
	if command_1 not in ["spawn","get","kill"]:
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
		
		
### 给予玩家物品(id)
func create_item_by_id(itemid:int):
	
	var test_0 = test_item.instantiate()
	test_0.set_info(AllItem.item_info(itemid))
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
	$UI/CommandWindow/LineEdit.clear()
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
	#控制台输出
	$UI/CommandWindow/console/RichTextLabel.text += "[color="+message_color+"]"+text+"[/color]"+"\n"


func _on_timer_timeout() -> void:
	create_item_by_id(randi()%27)
	pass # Replace with function body.
