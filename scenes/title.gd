extends Node2D

var process_start:float = 0.085
var process_end:float   = 2.0

var title_tween:Tween


func _ready() -> void:
	
	#$Title1.material.set_shader_parameter("Process",0.085)
	pass
func _on_button_pressed() -> void:
	#
	get_tree().change_scene_to_file("res://scenes/pre_game.tscn")
	queue_free()
	pass # Replace with function body.


func _on_area_2d_mouse_entered() -> void:
	print("yes")
	title_tween = get_tree().create_tween()
	title_tween.tween_method(set_title_shader_parameter,$Title1.material.get_shader_parameter("Process"),0.085,2.0)
	await title_tween.finished
	print("yes2")
	
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	title_tween.stop()
	title_tween = get_tree().create_tween()
	title_tween.tween_method(set_title_shader_parameter,$Title1.material.get_shader_parameter("Process"),2.0,2.0)
	pass # Replace with function body.

func set_title_shader_parameter(value:float):
	$Title1.material.set_shader_parameter("Process",value)
