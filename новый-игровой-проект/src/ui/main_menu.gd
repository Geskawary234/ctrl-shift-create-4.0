extends Control

@export var play_btn : Button
@export var settings_btn : Button
@export var settings : Control
@export var options : VBoxContainer
@export var quit_btn : Button

@onready var bg_music: FmodEventEmitter2D = $BgMusic
@onready var black_screen: ColorRect = $BlackScreen
const STARTING_COMIX = preload("uid://md8kbdyejjtl")
var colors : Array[Color] = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.AQUA,
	Color.FUCHSIA
]

func get_random_color(prev_color : Color):
	var c = colors.pick_random()
	if c == prev_color:
		return get_random_color(c)
	else:
		return c

func play_music():
	bg_music.play()
	
	bg_music.timeline_beat.connect(
		func(data):
			if data['beat'] % 2 != 0:
				
				$SpotLight3D.light_color = get_random_color($SpotLight3D.light_color)
				
			#print(data)
			
			)
	
func _ready() -> void:
	if Global.intro_played: $Intro.queue_free()
	black_screen.modulate = Color.TRANSPARENT
	
	get_tree().paused = false

	play_music()

	settings.hide()
	settings_btn.pressed.connect(func():
		settings.show()
		options.hide()
		)
	
	
	quit_btn.pressed.connect(func(): get_tree().quit())
	
	play_btn.pressed.connect(
		func():
			var t := create_tween()
			t.set_parallel(true)
			t.tween_property(bg_music,'volume',0,0.5)
			t.tween_property(black_screen,'modulate',Color.WHITE,1)
			await t.finished
			add_child(STARTING_COMIX.instantiate())
			
			)
	
	
	await get_tree().create_timer(9,false).timeout
	Global.intro_played = true
