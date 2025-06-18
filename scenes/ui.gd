extends Control

@onready var player = $"../../player"
#用以配合player单击行为
var ui_mouse_in:bool = false
var hand_is_null:bool = true


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("角色信息"):
		$player_info.visible = !$player_info.visible
		if $player_info.visible:
			player_info_show()
	if Input.is_action_just_pressed("装备信息"):
		$player_equipment.visible = !$player_equipment.visible

func player_info_show():
	var a = player.get_player_info()
	var label_text:String
	for key in a:
		label_text += key+":"
		label_text += str(a[key])+"\n"
	$player_info/NinePatchRect/RichTextLabel.text = label_text

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
