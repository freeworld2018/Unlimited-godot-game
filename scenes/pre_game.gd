extends Node2D
var switch_select = false
var switch_next_page = false
var select:int = -1

#data
var skill_point:int = 10
var skill_point_group = []

var main_scene = preload("res://scenes/main_scene.tscn")
#region 文本常量
#说明文本
const info_group = [
"力量是用来描述肌肉水平的值。
提高力量可以负载更重的装备而不会受到速度惩罚。",
"敏捷反应神经速度，也代表对肉体的掌握程度。
提高动作完成的速度。",
"智力代表智商水平。
影响阅读、解密、暗示、迷宫、学习等需要思考的时间。",
"意志代表心理健康程度，坚定的心。",
"体质连续行动的耐力值。",
"角色散发出的肉体魅力等级。
这会提高你附近的人和你交好的可能性。",
"知识代表掌握的世界情报量。
知识提供更多的信息，让你更可能无所不知。",
"魔力是对于魔法的掌握能力。"
]
const nick_name_A = [
	"无限","血腥","暴怒","闪亮","慈爱","梦幻","停不下来","永恒","快乐",
	"沉默","蹦蹦跳跳","双刃","魔法亲和","肌肉组成","灵巧","帅气","黑暗中","闪耀",
	"影","平衡","快乐","让人胆寒","长寿","鹰眼","熊爪","专注","多情","睡不醒","冒失",
	"无畏","调皮","倒霉","专用长剑","魔力充盈","火焰包裹","死亡","两个脑袋","雨中"
	]
const nick_name_connect = ["的","之"]
const nick_name_B = ["剑士","行路人","臭虫","酒鬼","王八蛋","勇士","法师","乞丐","硬汉",
	"刀斧手","刽子手","魔王","捣蛋鬼","护卫","鼠人","刀客","王者","帝王","假面","水塘",
	"炼金术士","开心鬼","亡魂","小伙","神秘人","沉默","青蛙","猫","赌鬼"
	]
const name_A = ["修","南宫","康米","李","朱","Nerd","斯卡","亚美","哈曼"]
const name_B = ["卡","天下","万岁","一旦","成","DDD","王","图里亚","提亚","斯克"]
#endregion
#UI位置控制
var ui_page:Vector2

signal select_changed


func _ready() -> void:
	ui_page = Vector2(get_window().size.x/2-200,get_window().size.y*0.1)
	$Control.position = ui_page
	select_changed.connect(_on_select_changed)
	skill_point_group.resize(8)
	skill_point_group.fill(0)
	$"Control/page1/剩余点数".text = "剩余可自由分配点数："+str(skill_point)
	_on_随机外号_button_down()
func _process(delta: float) -> void:
	if switch_select:
		var pos_y = get_local_mouse_position().y - $"Control/page1/属性".position.y - \
ui_page.y
		select =int(pos_y/25)
		select_changed.emit()
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		
		if switch_select and select !=  -1:
			if skill_point ==0:
				return	
			skill_point_group[select] += 1
			$"Control/page1/加点情况".get_children()[select].text = \
str(int($"Control/page1/加点情况".get_children()[select].text )+1)
			skill_point -= 1
			$"Control/page1/剩余点数".text = "剩余可自由分配点数："+str(skill_point)
			if skill_point == 0:
				$"Control/page1/下一页".visible = true
		if switch_next_page:
			if $Control/page2.visible:
				get_tree().change_scene_to_packed(main_scene)
				return
			$Control/page1.visible = false
			$Control/page2.visible = true
			
func _on_select_changed():
	var all = $"Control/page1/属性".get_children()
	for i in all:
		i.add_theme_color_override("font_color", Color.BLACK)
	if select == -1:
		return
	all[select].add_theme_color_override("font_color", Color.YELLOW)
	$"Control/详细信息".visible = true
	$"Control/详细信息".position.y = 240 + select*25
	$"Control/详细信息/信息".text = info_group[select]


func _on_属性_mouse_entered() -> void:
	switch_select = true
	pass # Replace with function body.


func _on_属性_mouse_exited() -> void:
	switch_select = false
	select = -1
	select_changed.emit()
	$"Control/详细信息".visible = false
	$"Control/详细信息".position.y = 240
	pass # Replace with function body.


func _on_button_button_down() -> void:
	skill_point = 10
	$"Control/page1/剩余点数".text = "剩余可自由分配点数："+str(skill_point)
	skill_point_group.clear()
	skill_point_group.resize(8)
	skill_point_group.fill(0)
	select_changed.emit()
	for i in $"Control/page1/加点情况".get_children():
		i.text = str(0)
	$"Control/page1/下一页".visible = false
	pass # Replace with function body.


func _on_下一页_mouse_entered() -> void:
	switch_next_page = true
	$"Control/page1/下一页".add_theme_color_override("font_color", Color.YELLOW)
	$"Control/page2/下一页".add_theme_color_override("font_color", Color.YELLOW)
	pass # Replace with function body.


func _on_下一页_mouse_exited() -> void:
	switch_next_page = false
	$"Control/page1/下一页".add_theme_color_override("font_color", Color.BLACK)
	$"Control/page2/下一页".add_theme_color_override("font_color", Color.BLACK)
	pass # Replace with function body.


func _on_随机外号_button_down() -> void:
	$Control/page2/LineEdit.text = nick_name_A[randi()%len(nick_name_A)]+\
	nick_name_connect[randi()%2]+nick_name_B[randi()%len(nick_name_B)]
	pass # Replace with function body.


func _on_随机本名_button_down() -> void:
	$Control/page2/LineEdit2.text = name_A[randi()%len(name_A)]+\
	" · "+name_B[randi()%len(name_B)]
	pass # Replace with function body.
