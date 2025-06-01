extends CanvasLayer

func _process(delta: float) -> void:
	$hand.position = get_local_mouse_position()
