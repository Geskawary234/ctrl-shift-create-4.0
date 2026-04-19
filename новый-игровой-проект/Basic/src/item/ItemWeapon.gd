extends PickableItem
class_name ItemWeapon


signal eqquiped
signal uneqquiped

@export var weapon_scene : Node
@export var normal_scene : Node

func _ready() -> void:
	normal_scene.show()
	weapon_scene.hide()
	
	eqquiped.connect(func():
		weapon_scene.show()
		normal_scene.hide()
		set_collision_layer_value(5,false)
	)
	
	uneqquiped.connect(func():
		weapon_scene.hide()
		normal_scene.show()
		set_collision_layer_value(5,true)
		)
	
func main():
	pass
