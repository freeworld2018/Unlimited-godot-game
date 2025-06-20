extends Node

### 关于信号总线的说明
### 1. S_item  简略自  Signal_item  表达 信号传递使用的参数
### 2.所有解耦部分必须在这里进行
###   命名规则说明
"""
		例 	   invenetory_get_item
		规则：  invenetory -> 发生位置
				get_item	  -> 发生行为
"""
###

signal invenetory_get_item(S_item:item,num:int)
signal invenetory_reduce_item(S_item:item,num:int)

signal hand_reduce_item(num:int)
signal hand_get_item(S_tiem,num:int)
signal hand_del_item()

signal npc_handle_create_npc_by_id()

signal item_bar_change()

signal player_set_item(S_item:item)
signal player_use_item(S_item:item)
signal player_equip_item(S_item:item)

###技能释放信号

signal player_start_charge()
signal player_release_charge(time:float)
signal player_skill_end()
