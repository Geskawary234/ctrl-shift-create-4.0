extends UsableItem


var stop_time : float = 2
@onready var emmiter: CPUParticles3D = $"Dihlofos 2/Node3D"
@onready var detect_roaches: Area3D = $"Dihlofos 2/DetectRoaches"
@onready var level: ProgressBar = $Control/Level
@onready var spray_sfx: FmodEventEmitter3D = $Spray

func _ready() -> void:
	super()
	in_inventory.connect(func(): level.hide())
	
var t : float = 0
var level_tween : Tween
func main():
	if level.value >= 100:
		emmiter.emitting = true
		t = stop_time
		
		level_tween = create_tween()
		level_tween.tween_property(level,'value',0,stop_time)
		
		spray_sfx.play()

func _process(delta: float) -> void:
	
	
	
	if t<=0:
		emmiter.emitting = false
	else:
		t-=delta
	
	if emmiter.emitting:
		
		for i in detect_roaches.get_overlapping_bodies():
			i.die()
	else:
		spray_sfx.stop()
	
		if level.value < 100:
			level.value += delta * 10

func thrown_func():
	super()
	level.hide()
	if level_tween:
		level_tween.stop()
	spray_sfx.stop()
	emmiter.emitting = false

func equip():
	super()
	level.show()	
