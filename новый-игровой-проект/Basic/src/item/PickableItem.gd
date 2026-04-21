extends Item
class_name PickableItem

signal eqquiped
signal thrown
signal in_inventory

@export var item_info : InventoryItem


func _ready() -> void:
	super()
	eqquiped.connect(equip)
	thrown.connect(thrown_func)

func equip():
	#print('equipped')
	set_collision_layer_value(5,false)

func thrown_func():
	#print('thrown')
	set_collision_layer_value(5,true)

func play_sound():
	super()
