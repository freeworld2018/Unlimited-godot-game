extends Node2D
@onready var test_item = load("res://scenes/item.tscn")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		$UI/LineEdit.unedit()
		$UI/LineEdit.release_focus()
		#print("quit")
		return
		var a  = test_item.instantiate()
		self.add_child(a)
		a.position = Vector2(100,0)
	return

func super_print(text:String):
	#控制台输出
	$UI/console/RichTextLabel.text += text+"\n"

func handle_command(text:String):
	var text_group = text.split(" ")
	if len(text_group) != 2:
		super_print("错误用法")
		return
	var command_1 = text_group[0]
	var command_2 = int(text_group[1])
	if command_1 not in ["spawn","get","kill"]:
		super_print("未知指令")
		return
	if typeof(command_2) != 2:
		super_print("错误数据")
		return
	match text_group[0]:
		"spawn":create_item_by_id(command_2)
		
		
func create_item_by_id(id:int):
	
	var a = AllItem.item_info(id)
	var test_0  = test_item.instantiate()
	test_0.set_info(a)
	self.add_child(test_0)
	test_0.position = Vector2(100,0)
	
	
	
func _on_line_edit_text_submitted(new_text: String) -> void:
	handle_command(new_text)
	$UI/LineEdit.clear()
	super_print(new_text)
	pass # Replace with function body.
