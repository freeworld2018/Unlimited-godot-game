extends item
#消耗品
var value:int
var effect:Array = []

func set_value(value:Array):
	super.set_value(value)
	self.value = value[4]
	self.value = value[5].duplicate()
