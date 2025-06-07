extends Control
@onready var inventroy = $"../Inventory"
@onready var main = $"../.."
@onready var player = $"../../player"
@onready var hand = $"../hand"
var item_bar_group_id =[] #物品栏 id数组
var item_bar_group = []   #物品栏 实例数组（Sprite2d
var item_bar_select_count:int = 0 #光标移动计数
###常量
const offset_x = 17
const offset_y = 45

func _ready() -> void:
	self.position = Vector2(get_window().size.x/2-$ItemBar.texture.get_size().x/2,get_window().size.y-10.0-$ItemBar.texture.get_size().y)
	item_bar_group_id.resize(8)
	item_bar_group_id.fill(-1)
	for i in range(8):
		var a = main.icon_item.instantiate()
		a.position = Vector2(offset_x+ i*64+32,offset_y+32)
		self.get_node("ItemBarBorder").add_child(a)
		item_bar_group.append(a)
	switch_current_item()
func _on_item_bar_change():
	#print("")
	#一个刷新物品栏显示的函数。 同时更新arm的手持物品
	item_bar_group_id = inventroy.item_group_id.slice(0,8)
	for i in range(8):
		if item_bar_group_id[i] == -1:
			item_bar_group[i].texture = null
			item_bar_group[i].set_number(1) #重置数字
		if item_bar_group_id[i] != -1:
			item_bar_group[i].set_number(inventroy.item_group[i].number)
			var a =AllItem.get_pic(item_bar_group_id[i])
			item_bar_group[i].texture = load(a[0])
			if a[1] == 0:
				item_bar_group[i].set_hframes(1)
				item_bar_group[i].set_vframes(1)
				item_bar_group[i].set_frame(0)
			if a[1] != 0:
				item_bar_group[i].set_hframes(16)
				item_bar_group[i].set_vframes(8)
				item_bar_group[i].set_frame(a[1]-1)
	if hand.is_null():
		player.set_current_item(item_bar_group_id[item_bar_select_count])
	pass
	
	
func del_item():
	inventroy.del_item(item_bar_select_count)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:  # 检查按键按下
# 检测 1-8 数字键
		for i in range(8):  # 0-7 对应 1-8
			if event.keycode == KEY_1 + i:  # KEY_1 对应数字1，KEY_2对应数字2，依此类推
				switch_current_item(i)  # 选中对应物品
				break  # 避免重复检测
	if Input.is_action_just_pressed("select"):
		if not player.can_use:
			return
		if not $ItemBarSelect.visible:
			return
		item_bar_select_count += 1
		if item_bar_select_count >7:
			item_bar_select_count =0
		switch_current_item(item_bar_select_count)

func switch_current_item(id:int = 0):#选择物品
	
	$ItemBarSelect.position =Vector2(offset_x+id*64,offset_y)
	item_bar_select_count = id
	if item_bar_group_id[id] != -1:
		if hand.is_null():
			player.set_current_item(item_bar_group_id[item_bar_select_count])
	if item_bar_group_id[id] == -1:
		player.set_current_item(-1)
