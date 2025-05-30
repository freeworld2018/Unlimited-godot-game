extends Node2D
@onready var test_item = load("res://scenes/item.tscn")

### 输入处理
func _input(event: InputEvent) -> void:
	# 禁用输入测试
	if Input.is_action_just_pressed("ui_cancel"):
		$UI/CommandWindow/LineEdit.unedit()
		$UI/CommandWindow/LineEdit.release_focus()
		return
		var a  = test_item.instantiate()
		self.add_child(a)
		a.position = Vector2(100,0)
	
	# 命令窗口显示
	if Input.is_action_just_pressed("CommandWindow"):
		$UI/CommandWindow.visible = !$UI/CommandWindow.visible
		if $UI/CommandWindow.visible:
			$UI/CommandWindow/LineEdit.editable = true
		else:
			$UI/CommandWindow/LineEdit.editable = false
	return

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
	if command_1 not in ["spawn","get","kill"]:
		super_print("未知指令")
		return
	if typeof(command_2) != 2:
		super_print("错误数据")
		return
	match text_group[0]:
		"spawn":create_item_by_id(command_2)

### 给予玩家物品(枪)
func create_item_by_id(id:int):
	var a = AllItem.item_info(id)
	var test_0  = test_item.instantiate()
	test_0.set_info(a)
	self.add_child(test_0)
	test_0.position = Vector2(100,0)

### 命令窗回车信号
func _on_line_edit_text_submitted(new_text: String) -> void:
	handle_command(new_text)
	$UI/CommandWindow/LineEdit.clear()
	super_print(new_text)
	pass # Replace with function body.

### 命令响应窗口
func super_print(text:String):
	#控制台输出
	$UI/CommandWindow/console/RichTextLabel.text += text+"\n"
