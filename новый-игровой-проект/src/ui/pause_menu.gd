extends Control

@onready var play: Button = $VBoxContainer/Play
@onready var settings: Button = $VBoxContainer/Settings
@onready var quit: Button = $VBoxContainer/Quit

@export var pause_manager : Node
@export var settings_ui : Control

func _ready() -> void:
	
	play.pressed.connect(
		func(): 
		hide()
		pause_manager.pause_tree()
		)
	
	settings.pressed.connect(func(): 
		settings_ui.show()
		hide()
		)
	
	quit.pressed.connect(func(): get_tree().change_scene_to_file('res://scenes/ui/main_menu.tscn'))
