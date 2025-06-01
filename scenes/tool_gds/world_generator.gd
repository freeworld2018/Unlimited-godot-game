extends Node2D
class_name world_generator


@export var ground_layer:TileMapLayer

# 瓦片和地图参数
var tile_size = Vector2i(16, 16)
var map_width = 64  # 宽度（瓦片数）
var map_height = 300  # 总高度
var ground_base_y = 0  # 地面基准
var max_peak_y = 200  # 山峰最低（Y 越大越低）
var min_valley_y = -100  # 谷地最高
var extend_threshold = 512.0

# 瓦片类型
var ground_tile = [Vector2i(0, 0),Vector2i(1, 0),Vector2i(2, 0)]   # 平地
var slope_45_tile = Vector2i(3, 0)  # 45° 斜坡
var fill_tile = [Vector2i(0, 1),Vector2i(1, 1),Vector2i(2, 1)]  # 填充

# 实体配置
var entity_scenes = {
	#"box": preload("res://Box.tscn"),
	#"jar": preload("res://Jar.tscn")
}
var spawn_points = []
var spawn_interval = 5

# 噪声生成
var noise = FastNoiseLite.new()

func _ready():
	# 初始化噪声
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_octaves = 4
	noise.frequency = 0.02  # 控制地形平滑度
	# 生成初始地图
	
	#spawn_initial_entities()

func _physics_process(delta):
	pass
	#var player_x = player.global_position.x
	#var map_right_edge = map_width * tile_size.x
	#if player_x > map_right_edge - extend_threshold:
		#extend_map_right()

func generate_map(start_x: int, end_x: int):
	var prev_height = 0
	for x in range(start_x, end_x):
		# 使用噪声生成地面高度
		var height = ground_base_y + int(noise.get_noise_1d(x) * 30)  # 高度波动 ±30
		#height = clamp(height, min_valley_y, max_peak_y)
		height = clamp(height, prev_height-1, prev_height + 1)
		if randf() > 0.6:
			height = prev_height
		# 放置地表瓦片
		ground_layer.set_cell(Vector2i(x, height), 0, ground_tile[randi_range(0,ground_tile.size()-1)], 0)
		
		
		# 检测斜坡（与左瓦片高度比较）
		if x > start_x:
			
			var slope_diff = height - prev_height
			
			if abs(slope_diff) >= 1:  # 高度差 1，放置斜坡
				var tile = slope_45_tile
				var tile_alter_index = 0
				if slope_diff < 0:
					# 上坡
					tile_alter_index = 2
					pass
				else:
					# 下坡
					tile_alter_index = 1
					pass
				ground_layer.set_cell(Vector2i(x, height), 0, tile, tile_alter_index)
				
			prev_height = height
		# 填充地下
		for y in range(height + 1, map_height):
			ground_layer.set_cell(Vector2i(x, y), 0, fill_tile[randi_range(0,fill_tile.size()-1)], 0)

		# 随机生成地面树木
		if randf() > 0.5:
			var tree_scene = null
			if randf() > 0.8:
				tree_scene = preload("res://scenes/entities/tree1.tscn")
			else:
				tree_scene = preload("res://scenes/entities/tree2.tscn")
			var tree = tree_scene.instantiate()
			tree.position = Vector2i(x * ground_layer.tile_set.tile_size.x, height * ground_layer.tile_set.tile_size.y)
			ground_layer.add_child(tree)



func spawn_initial_entities():
	for x in range(0, map_width, spawn_interval):
		var height = ground_base_y + int(noise.get_noise_1d(x) * 30)
		height = clamp(height, min_valley_y, max_peak_y)
		spawn_entity("box", Vector2i(x, height - 1))  # 实体在地面上

func extend_map_right():
	var new_column = map_width
	generate_map(new_column, new_column + 1)
	if new_column % spawn_interval == 0:
		var height = ground_base_y + int(noise.get_noise_1d(new_column) * 30)
		height = clamp(height, min_valley_y, max_peak_y)
		spawn_entity("box", Vector2i(new_column, height - 1))
	map_width += 1
	#var camera_script = camera.get_script()
	#if camera_script:
		#camera_script.max_bounds.x = map_width * tile_size.x

func spawn_entity(entity_type: String, coords: Vector2i):
	if entity_type in entity_scenes:
		var entity = entity_scenes[entity_type].instantiate()
		entity.position = ground_layer.map_to_local(coords)
		add_child(entity)
		spawn_points.append(coords)
