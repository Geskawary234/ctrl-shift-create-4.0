extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Button.pressed.connect(
		func():
			get_tree().change_scene_to_file('res://scenes/ui/main_menu.tscn')
	)
