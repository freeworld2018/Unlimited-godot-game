extends Control
###开关组
var switch_ctrl:bool
var switch_shift:bool
var switch_mouse_in:bool

###常量记录
const offset_x = 17
const offset_y = 45


###引用
@onready var  main_scene = self.get_parent().get_parent()


###数据存储
var item_group_id:Array[int] = []
var item_group:Array = []
func _ready() -> void:
	item_group_id.resize(64)
	item_group_id.fill(-1)
	item_group.resize(64)


func _process(delta: float) -> void:
	
	if switch_mouse_in:
		var pos = get_local_mouse_position()-Vector2(17,45)
		var pos_x = int(pos.x)/64
		pos_x = clamp(pos_x,0,8)
		var pos_y = int(pos.y)/64
		pos_y = clamp(pos_y,0,10)
		$ColorRect.position = Vector2(int(pos.x)/64*64+17 ,int(pos.y)/64*64+45)

func del_item(itemid:int,id:int):
	pass
func add_item(itemid:int,id:int = -1):
	#itemid 物品id， id：数组位置。
	
	for i in range(64):
		if item_group_id[i] == -1:
			item_group_id[i] = itemid
			var test_0  = main_scene.test_item.instantiate()
			test_0.set_info(AllItem.item_info(itemid))
			$InventoryBorder.add_child(test_0)
			var pos_x = i%8
			var pos_y = i/8
			test_0.position = Vector2(pos_x*64+offset_x+32,pos_y*64+offset_y+32)
			test_0.set_in_bag(true)
			return
	if id == -1:
		pass
		#item_group.append(a)
	pass


func _input(event: InputEvent) -> void:
	# 禁用输入测试
	if Input.is_action_just_pressed("inventory"):
		self.visible = !self.visible
		pass
		


func _on_area_2d_mouse_entered() -> void:
	switch_mouse_in = true
	$ColorRect.visible = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	switch_mouse_in = false
	$ColorRect.visible = false
	pass # Replace with function body.
