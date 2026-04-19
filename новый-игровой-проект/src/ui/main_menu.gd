extends Control

@export var play_btn : Button
@export var settings_btn : Button
@export var settings : Control
@export var options : VBoxContainer
@export var quit_btn : Button

func _ready() -> void:
	if Global.intro_played: $Intro.queue_free()
	
	get_tree().paused = false

	settings.hide()
	settings_btn.pressed.connect(func():
		settings.show()
		options.hide()
		)
	
	
	quit_btn.pressed.connect(func(): get_tree().quit())
	
	play_btn.pressed.connect(func(): get_tree().change_scene_to_file('res://tests/test_map.tscn'))
	
	
	await get_tree().create_timer(7,false).timeout
	Global.intro_played = true
