extends Area3D
class_name FmodEventArea

@export var fmod_event_path : String
@export var volume : float = 1
@export var restart_after_leaving : bool = false

var event : FmodEvent
func _ready():
	event = FmodServer.create_event_instance(fmod_event_path)
	event.volume = volume
	
	body_entered.connect(entered)
	body_exited.connect(exited)
	
	if !restart_after_leaving:
		event.start()
		event.set_paused(true)

	#event.start()
	#event.set_paused(true)
'''
func _process(delta: float) -> void:
	var bds : Array = get_overlapping_bodies()
	print(bds,' ',playing)
	if len(bds)<=0 and playing:
		exited(StaticBody3D.new())'''


func entered(_b):
	if restart_after_leaving:
		event.set_paused(false)
		event.start()
	else:
		event.paused = false

func exited(_b):
	if restart_after_leaving:
		event.stop(0)
	else:
		event.paused = true

	
