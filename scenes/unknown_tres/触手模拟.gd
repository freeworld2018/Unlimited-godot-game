extends Node2D

@onready var path: Path2D = $Path2D
@onready var line: Line2D = $Path2D/Line2D

var switch_p0 = false
var switch_p1 = false
var switch_p2 = false
var switch_p3 = false
func _ready():
	
	update_line()

func _process(delta: float) -> void:
	if switch_p0:
		$Marker2D.position = get_local_mouse_position()
	if switch_p1:
		$Marker2D2.position = get_local_mouse_position()
	if switch_p2:
		$Marker2D3.position = get_local_mouse_position()
	if switch_p3:
		$Marker2D4.position = get_local_mouse_position()
	update_line()
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up"):
		switch_p0 = !switch_p0
	if Input.is_action_just_pressed("ui_down"):
		switch_p3 = !switch_p3
	if Input.is_action_just_pressed("move_left"):
		switch_p1 = !switch_p1
		
	if Input.is_action_just_pressed("move_right"):
		switch_p2 = !switch_p2
		
# 将曲线采样点同步到 Line2D
func update_line():
	var curve = Curve2D.new()
	
	# 添加点（位置，入控制点，出控制点）
	curve.add_point($Marker2D.position, Vector2.ZERO, $Marker2D2.position-$Marker2D.position)  # 起点 (P0)
	curve.add_point($Marker2D4.position,$Marker2D3.position-$Marker2D.position, Vector2.ZERO) # 终点 (P3)
	
	path.curve = curve
	
	line.clear_points()
	for i in range(100):  # 100个采样点
		var t = i / 100.0
		line.add_point(path.curve.sample_baked(path.curve.get_baked_length() * t))
