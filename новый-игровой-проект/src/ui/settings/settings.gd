extends Control

@onready var audio_settings_btn: Button = $VBoxContainer/AudioSettingsBTN
@onready var graphics_settings_btn: Button = $VBoxContainer/GraphicsSettingsBTN

@export var pause_menu : Control

@onready var audio_settings: Control = $AudioSettings
@onready var graphics_settings: Control = $GraphicsSettings


func _ready() -> void:
	
	audio_settings.hide()
	graphics_settings.hide()
	
	audio_settings_btn.pressed.connect(
		func():
			audio_settings.show()
			graphics_settings.hide()
			)
	
	graphics_settings_btn.pressed.connect(
		func():
			audio_settings.hide()
			graphics_settings.show()
		
	)
	
	$VBoxContainer/Back.pressed.connect(
		func():
		Global.save_settings()
		hide()
		pause_menu.show()
		
		)
