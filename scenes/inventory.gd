extends Control
###开关组
var switch_ctrl:bool
var switch_shift:bool
var switch_mouse_in:bool

###常量记录
const offset_x = 17
const offset_y = 45


###引用
@onready var main_scene = self.get_parent().get_parent()
@onready var hand = self.get_parent().get_node("hand")
@onready var player = $"../../player"
###数据存储
var item_group_id:Array[int] = []
var item_group:Array = []
func _ready() -> void:
	item_group_id.resize(64)
	item_group_id.fill(-1)
	item_group.resize(80)



func _process(delta: float) -> void:
	
	if switch_mouse_in:
		var pos = get_local_mouse_position()-Vector2(17,45)
		var pos_x = int(pos.x)/64
		pos_x = clamp(pos_x,0,8)
		var pos_y = int(pos.y)/64
		pos_y = clamp(pos_y,0,10)
		$ColorRect.position = Vector2(int(pos.x)/64*64+17 ,int(pos.y)/64*64+45)

func del_item(id:int):
	print("删除物品"+str(id))
	#被zombie in village 引用
	item_group_id[id] = -1
	print(item_group[id])
	item_group[id].queue_free()
	item_group[id] = null
	pass
func add_item(itemid:int,id:int = -1):
	#被zombie in village 引用
	#itemid 物品id， id：数组位置。
	if id != -1:
		item_group_id[id] == itemid 
		if item_group[id] != null:
			item_group[id].queue_free()
		set_item(itemid,id)
		pass
	for i in range(64):
		if item_group_id[i] == -1:
			item_group_id[i] = itemid
			set_item(itemid,i)
			return
	
		#item_group.append(a)
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			print("?")
			if switch_mouse_in:
				#处理在物品栏进行单击的行为
				var pos = get_local_mouse_position()-Vector2(17,45)
				var pos_x = int(pos.x)/64
				pos_x = clamp(pos_x,0,8)
				var pos_y = int(pos.y)/64
				pos_y = clamp(pos_y,0,10)
				var select_id:int = pos_x+pos_y*8
				if is_null(select_id):
					if hand.is_null():
						return
					item_group_id[select_id] = hand.hand_item.get_id()
					item_group[select_id] = hand.hand_item
					item_group[select_id].reparent($InventoryBorder)
					item_group[select_id].position = Vector2(pos_x*64+offset_x+32,pos_y*64+offset_y+32)
					
					hand.clear()
					return
				#鼠标拿起物品
				item_group[select_id].reparent(hand.get_node("hand_item"))
				item_group[select_id].set_position(Vector2(0,0))
				item_group_id[select_id] = -1
				hand.hand_item = item_group[select_id]
				item_group[select_id] = null
			pass
	if Input.is_action_just_pressed("inventory"):
		self.visible = !self.visible
		pass
		

func set_item(itemid:int,id:int):
	#根据itemid生成物品并冷冻添加到节点中。
	var test_0  = main_scene.test_item.instantiate()
	test_0.set_info(AllItem.item_info(itemid))
	$InventoryBorder.add_child(test_0)
	var pos_x = id%8
	var pos_y = id/8
	test_0.position = Vector2(pos_x*64+offset_x+32,pos_y*64+offset_y+32)
	test_0.set_in_bag(true)
	item_group[id] = test_0

func is_null(id:int):
	if item_group_id[id] == -1:
		return true

func _on_area_2d_mouse_entered() -> void:
	switch_mouse_in = true
	$ColorRect.visible = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	switch_mouse_in = false
	$ColorRect.visible = false
	pass # Replace with function body.
