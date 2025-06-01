extends Node2D


@export var player:Node2D
@export var generator:world_generator

var start_position:Vector2
var block_size = 32
var gen_x_length = 128
var gen_x_min = 0
var gen_x_max = 0
var version_x_size = 64

func _init() -> void:
	if player:
		start_position = player.position
	#if generator:
		#update_map()

func _process(delta: float) -> void:
	
	update_state()
	update_map()
	check_player_position()

func update_map():
	if !player or !generator:
		return
	var player_px = player.position.x / block_size
	if player_px - version_x_size <= gen_x_min:
		generator.generate_map(gen_x_min-gen_x_length, gen_x_min)
		gen_x_min -= gen_x_length
	if player_px + version_x_size >= gen_x_max:
		generator.generate_map(gen_x_max,gen_x_max+gen_x_length)
		gen_x_max += gen_x_length

func update_state():
	if player:
		
		$UI/Pos.text = "(%d,%d)" % [player.position.x / block_size, player.position.y / block_size]
func check_player_position():
	if !player:
		return
	if player.position.y > 1000 or player.position.y < -1000:
		player.position = start_position
