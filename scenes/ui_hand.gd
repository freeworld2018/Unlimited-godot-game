extends Control

var hand_item:Sprite2D#icon_item
@onready var ui = $".."

func _ready() -> void:
	SignalBus.hand_reduce_item.connect(_on_item_reduce)
	SignalBus.hand_del_item.connect(del_item)
func del_item():
	self.hand_item.queue_free()
	self.hand_item = null
func set_item(icon:Sprite2D):
	self.hand_item = icon
	SignalBus.player_set_item.emit(hand_item.self_item)
func _process(delta: float) -> void:
	$hand_item.position = get_local_mouse_position()
	pass
func is_null():
	if $hand_item.get_child_count() > 0:
		ui.hand_is_null = false
		return false
	else:
		ui.hand_is_null = true
		return true
func clear():
	hand_item = null
	
func _on_item_reduce():
	self.hand_item.add(-1)
	if self.hand_item.quantity ==0:
		self.del_item()
		SignalBus.item_bar_change.emit()
	
