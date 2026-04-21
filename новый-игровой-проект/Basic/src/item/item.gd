extends RigidBody3D
class_name Item

@onready var object_throw: FmodEventEmitter3D = $ObjectThrow


func _ready() -> void:
	body_entered.connect(func(b): 
		play_sound()
		)


var sound_cooldown : float = 0.5

var cooldown_timer : float = 1
func play_sound():
	if linear_velocity.length()<0.1: return
	
	if cooldown_timer<=0:
		object_throw.play_one_shot()
		cooldown_timer = sound_cooldown
		
func _process(delta: float) -> void:
	if cooldown_timer>0:
		cooldown_timer -= delta
		
