@tool
extends TutorialNode

@export var knock_knock : FmodEventEmitter3D
@export var stop_knocking_area : SoundArea
@export var door_dial_area : SoundArea			

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint(): return
	
	finished.connect(transition)

func transition():
	await get_tree().create_timer(2,false).timeout
	setup_next.emit()
			
	knock_knock.play()
	stop_knocking_area.enable = true
	door_dial_area.enable = true
			
	disconnect('finished',transition)
	
