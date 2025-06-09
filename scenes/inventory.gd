extends Control
###开关组
var switch_ctrl:bool
var switch_shift:bool
var switch_mouse_in:bool
var switch_full:bool

###常量记录
const offset_x = 17  #针对物品栏的偏移常量
const offset_y = 45

var icon_item = load("res://scenes/icon_item.tscn")
###引用
@onready var  ui = get_parent()
@onready var  hand = $"../hand"


###数据存储
var item_group_id:Array[int] = []   #id索引
var item_group:Array[Sprite2D] = []   		#实例数组
var item_emptyslots:int = 80  		#空位
func _ready() -> void:
	item_group_id.resize(80)
	item_group_id.fill(-1)
	item_group.resize(80)
	SignalBus.invenetory_get_item.connect(add_item)
	SignalBus.invenetory_reduce_item.connect(reduce_item)

func _process(delta: float) -> void:
	
	if switch_mouse_in:
		var pos = get_local_mouse_position()-Vector2(17,45)
		var pos_x = int(pos.x)/64
		pos_x = clamp(pos_x,0,8)
		var pos_y = int(pos.y)/64
		pos_y = clamp(pos_y,0,10)
		$ColorRect.position = Vector2(int(pos.x)/64*64+17 ,int(pos.y)/64*64+45)

func del_item(index:int):
	
	if item_group[index].quantity == 0:
		print("删除物品"+str(index))
		item_group_id[index] = -1
		item_group[index].queue_free()
		item_group[index] = null
		set_item_emptyslots(+1)
	if index < 8:
		SignalBus.item_bar_change.emit()
	pass
func add_item_by_id(itemid:int,id:int = -1): #暂时弃用
	if not AllItem.get_item(itemid).stack:
		for i in range(80):
			if item_group_id[i] == -1:
				item_group_id[i] = itemid
				set_item(AllItem.get_item(itemid),i)
				SignalBus.item_bar_change.emit()
				return
	if itemid in item_group_id:
		item_group[item_group_id.find(itemid)].add(1)
		SignalBus.item_bar_change.emit()
		return
	#被zombie in village 引用
	#itemid 物品id， id：数组位置。
	if id != -1:
		item_group_id[id] == itemid 
		if item_group[id] != null:
			item_group[id].queue_free()
		set_item(AllItem.get_item(itemid),id)
		pass
	for i in range(80):
		if item_group_id[i] == -1:
			item_group_id[i] = itemid
			set_item(AllItem.get_item(itemid),i)
			SignalBus.item_bar_change.emit()
			return
	#SignalBus.item_bar_change.emit()
		#item_group.append(a)
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if switch_mouse_in:
			if event.button_index == MOUSE_BUTTON_LEFT:
				#处理在物品栏进行左键单击的行为
				var pos = get_local_mouse_position()-Vector2(17,45)
				var pos_x = int(pos.x)/64
				pos_x = clamp(pos_x,0,8)
				var pos_y = int(pos.y)/64
				pos_y = clamp(pos_y,0,10)
				var select_id:int = pos_x+pos_y*8
				print(str(select_id))
				if is_null(select_id): #当目标位置为空,且手上非空的时候执行放置物品
					if hand.is_null():
						return
					#放置手中物品的逻辑
					item_group_id[select_id] = hand.hand_item.get_id()
					item_group[select_id] = hand.hand_item
					item_group[select_id].reparent($InventoryBorder)
					item_group[select_id].position = Vector2(pos_x*64+offset_x+32,pos_y*64+offset_y+32)
					hand.clear()
					set_item_emptyslots(-1)
					SignalBus.item_bar_change.emit()
					return
				#鼠标拿起物品
				if hand.is_null():#手上空，目标位置不为空的时候
					item_group[select_id].reparent(hand.get_node("hand_item"))
					item_group[select_id].set_position(Vector2(0,0))
					item_group_id[select_id] = -1
					set_item_emptyslots(+1)
					SignalBus.item_bar_change.emit()
					hand.set_item(item_group[select_id])
					item_group[select_id] = null
					return
				#交换物品
				if hand.hand_item.get_id() == item_group_id[select_id]:
					if AllItem.get_item(hand.hand_item.get_id()).stack:
						item_group[select_id].add(hand.hand_item.quantity)
						hand.del_item()
						hand.clear()
						SignalBus.item_bar_change.emit()
						return 
						pass
				var exchange_item = item_group[select_id]
				item_group_id[select_id] = hand.hand_item.get_id()
				item_group[select_id] = hand.hand_item
				item_group[select_id].reparent($InventoryBorder)
				item_group[select_id].position = Vector2(pos_x*64+offset_x+32,pos_y*64+offset_y+32)
				exchange_item.reparent(hand.get_node("hand_item"))
				exchange_item.set_position(Vector2(0,0))
				SignalBus.item_bar_change.emit()
				hand.set_item(exchange_item)
			
			if event.button_index == MOUSE_BUTTON_RIGHT:
				var pos = get_local_mouse_position()-Vector2(17,45)
				var pos_x = int(pos.x)/64
				pos_x = clamp(pos_x,0,8)
				var pos_y = int(pos.y)/64
				pos_y = clamp(pos_y,0,10)
				var select_id:int = pos_x+pos_y*8
				print(str(select_id))
				if is_null(select_id): #当目标位置为空,且手上非空的时候执行放置物品
					return
				#对目标位置的操作： 右键获取一个
				if hand.is_null():
					var test_0  = icon_item.instantiate()
					test_0.set_info(AllItem.get_item(item_group_id[select_id]))
					hand.get_node("hand_item").add_child(test_0)
					hand.hand_item = test_0
					item_group[select_id].add(-1)
					if item_group[select_id].quantity == 0:
						item_group_id[select_id] = -1
						item_group[select_id].queue_free()
						item_group[select_id] = null
					SignalBus.item_bar_change.emit()
					return
				#当手上有东西的时候 对着同物品
				if hand.hand_item.get_id() == item_group_id[select_id]:
					if not hand.hand_item.self_item.stack:
						return
					hand.hand_item.add(1)
					item_group[select_id].add(-1)
					if item_group[select_id].quantity == 0:
						item_group_id[select_id] = -1
						item_group[select_id].queue_free()
						item_group[select_id] = null
					SignalBus.item_bar_change.emit()
				return
				#对着不同物品啥都不做
			pass
	if Input.is_action_just_pressed("inventory"):
		self.visible = !self.visible
		pass
		

func can_pick_item(S_item:item):
	if S_item.stack:
		if S_item.id in item_group_id:
			return true
		for i in range(80):
			if item_group_id[i] == -1:
				return true
	for i in range(80):
		if item_group_id[i] == -1:
			return true
	return false
	pass


func add_item(S_item:item,num:int):  #添加物品
	if S_item.stack:
		if S_item.id in item_group_id:
			var index = item_group_id.find(S_item.id)
			item_group[index].add(num)
			if index < 8:
				SignalBus.item_bar_change.emit()
			return
		for i in range(80):
			if item_group_id[i] == -1:
				item_group_id[i] = S_item.id
				set_item(S_item,i)
				if i < 8:
					SignalBus.item_bar_change.emit()
				return
	for i in range(80):
		if item_group_id[i] == -1:
			item_group_id[i] = S_item.id
			set_item(S_item,i)
			if i < 8:
				SignalBus.item_bar_change.emit()
			return
	pass

func set_item(S_item:item,id:int):#从未使用
	#根据itemid生成物品并冷冻添加到节点中。
	var test_0  = icon_item.instantiate()
	test_0.set_info(S_item)
	$InventoryBorder.add_child(test_0)
	var pos_x = id%8
	var pos_y = id/8
	test_0.position = Vector2(pos_x*64+offset_x+32,pos_y*64+offset_y+32)
	item_group[id] = test_0
	set_item_emptyslots(-1)
	
func reduce_item(index:int,num:int):
	item_group[index].reduce(num)
	if item_group[index].quantity == 0:
		del_item(index)
		return
	if index < 8:
		SignalBus.item_bar_change.emit()
	pass
func is_null(id:int): #判断某一位是否为-1（无物品）
	if item_group_id[id] == -1:
		return true

func set_item_emptyslots(value:int):
	if value == 0:
		return
	if item_emptyslots == 1 and value == -1:
		pass
		#player.set_mask(false)
	if item_emptyslots == 0 and value > 0:
		pass
		#player.set_mask(true)
	item_emptyslots += value


func _on_container_mouse_entered() -> void:
	switch_mouse_in = true
	ui.ui_mouse_in = true
	$ColorRect.visible = true
	pass # Replace with function body.


func _on_container_mouse_exited() -> void:
	switch_mouse_in = false
	ui.ui_mouse_in = false
	$ColorRect.visible = false
	pass # Replace with function body.
