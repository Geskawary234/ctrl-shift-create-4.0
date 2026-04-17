extends Node

@onready var pause_menu: Control = $"../SpringArm3D/CameraPivot/Camera3D/PauseMenu"
@onready var settings: Control = $"../SpringArm3D/CameraPivot/Camera3D/Settings"

@onready var tree := get_tree()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	settings.hide()
	pause_menu.hide()
	
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('escape'):
		if tree.paused and !pause_menu.is_visible(): return
		
		pause_tree()
		

func pause_tree():
	tree.paused = !tree.paused 
		
	if tree.paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause_menu.show()
	else:
		pause_menu.hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
