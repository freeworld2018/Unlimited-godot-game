extends Control


@onready var inventroy = $"../Inventory"
@onready var hand = $"../hand"
@onready var ui= $".."
var item_bar_group_id =[] #物品栏 id数组
var item_bar_group = []   #物品栏 实例数组（Sprite2d
var item_bar_select_count:int = 0 #光标移动计数
###常量
const offset_x = 17
const offset_y = 45

func _ready() -> void:
	SignalBus.item_bar_change.connect(_on_item_bar_change)
	self.position = Vector2(get_window().size.x/2-$ItemBar.texture.get_size().x/2,get_window().size.y-10.0-$ItemBar.texture.get_size().y)
	item_bar_group_id.resize(8)
	item_bar_group_id.fill(-1)
	for i in range(8):
		var a = inventroy.icon_item.instantiate()
		a.position = Vector2(offset_x+ i*64+32,offset_y+32)
		self.get_node("ItemBarBorder").add_child(a)
		item_bar_group.append(a)
	switch_current_item()
func _on_item_bar_change():
	item_bar_group_id = inventroy.item_group_id.slice(0,8)
	for i in range(8):
		if item_bar_group_id[i] == -1:
			item_bar_group[i].texture = null
			item_bar_group[i].set_quantity(1) #重置数字
		if item_bar_group_id[i] != -1:
			item_bar_group[i].set_quantity(inventroy.item_group[i].quantity)
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
		if inventroy.item_group_id[item_bar_select_count] == -1:
			SignalBus.player_set_item.emit(AllItem.get_null_item())
			return
		SignalBus.player_set_item.emit(inventroy.item_group[item_bar_select_count].self_item)
	pass
	
	
func del_item():
	inventroy.del_item(item_bar_select_count)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:  # 检查按键按下
# 检测 1-8 数字键
		for i in range(8):  # 0-7 对应 1-8
			if event.keycode == KEY_1 + i:  # KEY_1 对应数字1，KEY_2对应数字2，依此类推
				if not ui.player_can_use():
					return   #使用物品时 无法切换
				if not $ItemBarSelect.visible:
					return
				switch_current_item(i)  # 选中对应物品
				break  # 避免重复检测
	if Input.is_action_just_pressed("select"):
		if not ui.player_can_use():
			return   #使用物品时 无法切换
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
			SignalBus.player_set_item.emit(inventroy.item_group[item_bar_select_count].self_item)
	if item_bar_group_id[id] == -1:
		SignalBus.player_set_item.emit(AllItem.get_null_item())
