extends Pawn
class_name PlayerHumanPawn

@export var speed : float = 3
@export var spring_len : float = 5

@onready var col_shape: Shape3D = $CollisionShape3D.shape
@onready var footsteps: FmodEventEmitter3D = $Footsteps

var playing : bool = false
var step_time : float = 0.4

var time : float = 0
func _process(delta: float) -> void:
	var hor_vel : Vector3 = linear_velocity
	hor_vel.y = 0
	if hor_vel.length()>0.1:
		if time<=0:
			footsteps.play()
			time = step_time
		else:
			time -= delta
	else:
		time = 0
		footsteps.stop()
