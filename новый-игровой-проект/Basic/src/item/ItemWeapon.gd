extends PickableItem
class_name UsableItem



@export var in_hands_scene : Node
@export var normal_scene : Node

func _ready() -> void:
	super()
	eqquiped.connect(func():
		if in_hands_scene and normal_scene:
			in_hands_scene.show()
			normal_scene.hide()
		equip()
	)
	
	thrown.connect(func():
		if in_hands_scene and normal_scene:
			in_hands_scene.hide()
			normal_scene.show()
		thrown_func()
		)
	
	thrown.emit()



func main():
	pass
