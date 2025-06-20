extends Control
var equipment_0:item #背部
var equitment_1:item 
var equitment_2:item
var equitment_3:item
var equitment_4:item
var equipment_5:item
var equipment_6:item
var equipment_7:item
var equipment_8:item
var equipment_9:item #腰间

@onready var 背部 = $"NinePatchRect/背部/Sprite2D"
@onready var 腰部 = $"NinePatchRect/腰部/Sprite2D"

func _ready() -> void:
	SignalBus.player_equip_item.connect(_on_equip_item)

func _on_equip_item(S_item:item):
	if S_item.type in [5,6,7,8]:
		equipment_0 = S_item
		背部.texture = AllItem.weapon_icon_pic_group[0]
		背部.set_hframes(8)
		背部.set_vframes(1)
		背部.set_frame(S_item.type-5)
	if S_item.type in [5,6,7,8]:
		equipment_9 = S_item
		腰部.texture = AllItem.weapon_icon_pic_group[0]
		腰部.set_hframes(8)
		腰部.set_vframes(1)
		腰部.set_frame(S_item.type-5)
		
	pass
