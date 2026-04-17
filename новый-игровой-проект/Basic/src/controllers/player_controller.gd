extends CameraController
class_name PlayerController

func _ready() -> void:
	super()

func control_pawn(delta : float):
	super(delta)
	
	var dir : Vector3
	match camera_mode:
		0:
			dir = first_person_move()
		1:
			dir = third_person_move()

	pawn.linear_velocity.x = dir.x * 5
	pawn.linear_velocity.z = dir.z * 5

func first_person_move():
	var dir : Vector3 = pawn.global_basis * Vector3(input.x,0,input.y)
	
	return dir
	
	
	#pawn.position.x += dir.x * delta * 5
	#pawn.position.z += dir.z * delta * 5
	

func third_person_move():
	var e_basis : Vector3 = camera.global_basis.get_euler()
	e_basis.x = 0
	var c_basis : Basis = Basis.from_euler(e_basis)
	var dir : Vector3 = c_basis * Vector3(input.x,0,input.y)
	
	pawn.linear_velocity.x = dir.x * 5
	pawn.linear_velocity.z = dir.z * 5
	
	var dot : float = GameServer.interpolated_look_at(pawn,pawn.global_position + dir)
	
	return dir
