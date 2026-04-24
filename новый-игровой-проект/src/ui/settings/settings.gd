extends Control

@onready var audio_settings_btn: Button = $VBoxContainer/AudioSettingsBTN
@export var pause_menu : Control

func _ready() -> void:
	
	$AudioSettings.hide()
	audio_settings_btn.pressed.connect(
		func():
			$AudioSettings.show()
			
		
			)
	
	$VBoxContainer/Back.pressed.connect(
		func():
		Global.save_settings()
		hide()
		pause_menu.show()
		
		)
