extends item
class_name weapon #武器
var weapon_name:String


enum WeaponType {
	长剑 = 0,   # 长剑
	法杖 = 1,        # 法杖
	刀   = 2,        # 刀
	细剑 = 3,       # 细剑
	短剑 = 4,  # 短剑
	短刀 = 5,        # 短刀
	匕首 = 6,       # 匕首
	魔杖 = 7          # 魔杖
}

enum MaterialType {
	铁 = 0,     #最常见的材料，也拥有最常见的普通效果。
	橡木 = 1,      
	松木 = 2,           
	钢 = 3,         
	合金 = 4,         
	玻璃 = 5,         
	水晶 = 6,        
	魔力回应石 = 7,      
	骨头 = 8,     
	黄金 = 9,
	白银 = 10
}
const WeaponType_group = ["长剑", "法杖", "刀", "细剑", "短剑", "短刀", "匕首", "魔杖"]
const MaterialTypes_group = ["铁", "橡木", "松木", "钢", "合金", "玻璃", "水晶",\
 "魔力回应石", "骨头", "黄金", "白银"]
const type_volume_factor =  [8,8,8,6,4,4,4,4]
const type_atk_power_factor =[8,4,8,4,3,3,3,4]
const material_weight_factor= [10,7,6,9,8,5,4,4,3,15,13]
const material_atk_power_factor =[8,4,4,10,12,2,4,20,6,2,8]
var material:int
var price:int
var attack_power:int
var weight:int
var level:int
var desp = []
var good_desp= [] 
var bad_desp= [] 
var tag = []

func set_value(value:Array):
	#参数举例  value=[name,type,icon_pic,id,material]
	super.set_value(value)
	self.weapon_name=value[0]
	self.material =value[4]
	self.attack_power=value[5]
	self.weight = value[6]
	self.level = value[7]
	self.desp = value[8].duplicate()
	self.good_desp = value[9].duplicate()
	self.bad_desp = value[10].duplicate()
	
