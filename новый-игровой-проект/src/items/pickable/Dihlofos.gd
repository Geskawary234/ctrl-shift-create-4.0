extends UsableItem


var stop_time : float = 2
@onready var emmiter: CPUParticles3D = $"Dihlofos 2/Node3D"
@onready var detect_roaches: Area3D = $"Dihlofos 2/DetectRoaches"

@onready var spray_event : FmodEvent = FmodServer.create_event_instance('event:/GAS')

func _ready() -> void:
	super()
	
var t : float = 0
func main():
	emmiter.emitting = true
	t = stop_time
	
	spray_event.start()

func _process(delta: float) -> void:
	if t<=0:
		emmiter.emitting = false
	else:
		t-=delta
	
	if emmiter.emitting:
		
		for i in detect_roaches.get_overlapping_bodies():
			i.die()
	else:
		spray_event.stop(0)

func thrown_func():
	super()
	spray_event.stop(0)
		
	
