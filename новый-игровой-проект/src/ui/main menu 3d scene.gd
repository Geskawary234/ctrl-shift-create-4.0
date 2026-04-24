extends Node3D

@onready var cocroch_ap : AnimationPlayer = $"../cocroch_model/cocroch".get_node('AnimationPlayer')
@onready var cocroch: Node3D = $"../cocroch_model"

var x_rotation_speed : float = 5
var y_rotation_speed : float = 5

var next_random_x_speed : float = x_rotation_speed
var next_random_y_speed : float = y_rotation_speed
func _process(delta: float) -> void:
	cocroch.rotate_object_local(Vector3.UP,delta * y_rotation_speed)
	cocroch.rotate_x(delta * x_rotation_speed)
	
	if randi_range(0,100) == 0:
		if randi_range(0,1) == 0:
			next_random_x_speed = randf_range(-5,5)
		else:
			next_random_y_speed = randf_range(-5,5)
	
	x_rotation_speed = move_toward(x_rotation_speed,next_random_x_speed,delta * 2)
	y_rotation_speed = move_toward(y_rotation_speed,next_random_y_speed,delta * 2)
	
	if !cocroch_ap.is_playing(): cocroch_ap.play('2_Walk_Fix_001')
