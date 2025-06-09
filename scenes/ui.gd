extends Control

@onready var player = $"../../player"
#用以配合player单击行为
var ui_mouse_in:bool = false
var hand_is_null:bool = true

func get_hand_item():
	return $hand.hand_item.self_item

func can_pick(S_item:item):
	print($Inventory.can_pick_item(S_item))
	return $Inventory.can_pick_item(S_item)
	pass

func get_select_count():
	return $item_bar.item_bar_select_count

func player_can_use():
	return player.can_use
