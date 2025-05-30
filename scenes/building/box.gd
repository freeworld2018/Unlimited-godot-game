extends Sprite2D

var include:Array[int] = []
@onready var box_open = load("res://gane_assets/art/back_pic/box_open.png")
@onready var box_close = load("res://gane_assets/art/back_pic/box.png")

func _on_area_2d_mouse_entered() -> void:
	self.material.set_shader_parameter("outline_width",1.0)
	self.texture = box_open
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	self.material.set_shader_parameter("outline_width",0.0)
	self.texture = box_close
	pass # Replace with function body.
