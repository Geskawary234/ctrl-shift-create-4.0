extends ItemWeapon


var stop_time : float = 2
@onready var emmiter: CPUParticles3D = $"Dihlofos 2/Node3D"
@onready var detect_roaches: Area3D = $"Dihlofos 2/DetectRoaches"
@onready var fmod_event_emitter_3d: FmodEventEmitter3D = $FmodEventEmitter3D



func _ready() -> void:
	super()
	
var t : float = 0
func main():
	emmiter.emitting = true
	t = stop_time
	
	fmod_event_emitter_3d.play()

func _process(delta: float) -> void:
	if t<=0:
		emmiter.emitting = false
	else:
		t-=delta
	
	if emmiter.emitting:
		
		for i in detect_roaches.get_overlapping_bodies():
			i.die()
	else:
		fmod_event_emitter_3d.stop()
	
	
		
	
