extends Control

@export var frames : Array[Texture2D]
@export var frame_index : int = 0


@onready var frame: TextureRect = $Frame
@onready var next_button: Button = $NextButton
@onready var skip_hint_anim : AnimationPlayer = $SkipHint/AnimationPlayer


var comix_music : FmodEvent
func _ready() -> void:
	frame.modulate = Color.TRANSPARENT
	$SkipHint.modulate = Color.TRANSPARENT
	next_button.hide()
	next_button.pressed.connect(func(): get_tree().change_scene_to_file('res://scenes/game_map.tscn'))
	
	FmodServer.add_listener(0,self)
	comix_music = FmodServer.create_event_instance('event:/Comix Music')
	comix_music.volume = 0
	comix_music.start()
	
	
	var t := create_tween()
	t.tween_property(comix_music,'volume',1,3)
	await t.finished
	
	play_comix()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		skip_hint_anim.play('blink')
		
		if event.keycode == 32:
			get_tree().change_scene_to_file('res://scenes/game_map.tscn')

func play_comix():
	#await get_tree().create_timer(0.5,false)
	var t := create_tween()
	frame.texture = frames[frame_index]
	t.tween_property(frame,'modulate',Color.WHITE,1)
	await t.finished
	
	await get_tree().create_timer(2,false).timeout
	
	if frame.texture != frames[-1]:
		t = create_tween()
		t.tween_property(frame,'modulate',Color.TRANSPARENT,1)
		await t.finished
	
	await get_tree().create_timer(0.5,false).timeout
	
	if frame_index + 1 < len(frames):
		frame_index += 1
		play_comix()
	else:
		next_button.disabled = true
		next_button.modulate = Color.TRANSPARENT
		next_button.show()
		
		t = create_tween()
		t.tween_property(next_button,'modulate',Color.WHITE,0.5)
		await t.finished
		next_button.disabled = false
		
	
	
	
	
	
	
