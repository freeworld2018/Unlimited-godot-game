extends Node2D

@export var hp:int = 5
@export var hit_effect_scene:PackedScene

signal destroyed(entity:Node2D)

func death():
	destroyed.emit(self)
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			#var click_position = get_global_mouse_position
			
			if hit_effect_scene:
				# 实例化特效
				var effect = hit_effect_scene.instantiate()
				add_child(effect)
				effect.global_position = get_global_mouse_position()
				
			hp -= 1
			if hp <= 0:
				death()
			pass
	pass # Replace with function body.
