extends Control

@onready var play: Button = $VBoxContainer/Play
@onready var settings: Button = $VBoxContainer/Settings
@onready var quit: Button = $VBoxContainer/Quit

@export var pause_manager : Node
@export var settings_ui : Control

func _ready() -> void:
	
	play.pressed.connect(pause_manager.pause_tree)
	
	settings.pressed.connect(func(): 
		settings_ui.show()
		hide()
		)
