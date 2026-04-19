extends CameraController
class_name PlayerController

@export var speed : float = 5

func _ready() -> void:
	super()

func control_pawn(delta : float):
	super(delta)
	
	var dir : Vector3
	if camera.current:
		match camera_mode:
			0:
				dir = first_person_move()
			1:
				dir = third_person_move()

		pawn.linear_velocity.x = dir.x * speed
		pawn.linear_velocity.z = dir.z * speed
	
	

func first_person_move():
	var dir : Vector3 = pawn.global_basis * Vector3(input.x,0,input.y)
	
	return dir
	
	
	#pawn.position.x += dir.x * delta * 5
	#pawn.position.z += dir.z * delta * 5
var initial_cam_position : Vector3
var cam_shake_time : float = 0
func camera_shake(delta : float):
	var d : Vector3 = pawn.linear_velocity.normalized()
	d.y = 0
	
	if d:
		cam_shake_time += delta * 15
		camera.position = lerp(camera.position,sin(cam_shake_time) * Vector3(0,0.1,0) + initial_cam_position,0.5)
	else:
		cam_shake_time = 0
		camera.position = lerp(camera.position,initial_cam_position,0.5)
	
func third_person_move():
	var e_basis : Vector3 = camera.global_basis.get_euler()
	e_basis.x = 0
	var c_basis : Basis = Basis.from_euler(e_basis)
	var dir : Vector3 = c_basis * Vector3(input.x,0,input.y)
	
	#pawn.linear_velocity.x = dir.x * speed
	#pawn.linear_velocity.z = dir.z * speed
	
	var dot : float = GameServer.interpolated_look_at(pawn,pawn.global_position + dir)
	
	return dir

func pawn_changed(old : Pawn):
	super(old)
	
	initial_cam_position = camera.position
