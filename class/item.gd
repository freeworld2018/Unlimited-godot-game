extends Node
class_name item  # 物品/掉落物
var item_name:String
var type:int
var icon_pic:String
var id:int

"""
type 0  - 空位
type 1  - 食物
type 2  - 水
type 3  - 药剂
type 4  - 建筑物
type 5 6 7 8 9 10 11 12  武器



"""

func get_id():
	return id
