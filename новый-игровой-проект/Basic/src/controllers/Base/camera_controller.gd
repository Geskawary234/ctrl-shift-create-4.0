extends Controller
class_name CameraController

@export_enum('1st person','3rd person') var camera_mode = 1 :
	set(v):
		
		camera_mode = v
		update_camera_mode(v)
		
		
			
		
		
@export var allow_mode_change : bool = true
@export var camera : Camera3D
@export var camera_pivot : Node3D
@export var spring_arm : SpringArm3D
@onready var spring_arm_len : float = spring_arm.spring_length


var sens : float = 0.004
var mouse_input : Vector2
var input : Vector2

func _ready() -> void:
	super()
	update_camera_mode(camera_mode)

func update_camera_mode(v : int):
	if camera:
		camera.rotation.x = 0
		camera.rotation.y  = 0
		
	if spring_arm and pawn:
		match v:
			0:
				camera.reparent(pawn,false)
					#camera.position = Vector3(0,0.5,0)
					
			1:
				camera.reparent(camera_pivot,false)
					#camera.position = Vector3(0,0.5,0)
				pawn.angular_velocity.y = 0
	

func _input(event: InputEvent) -> void:
	# mouse input is controlled by pawn
	if event is InputEventMouseMotion:
		mouse_input = -event.relative * sens

func pawn_process(delta: float) -> void:
	super(delta)
	if camera_mode == 1:
		follow_pawn()
		
	control_pawn(delta)
	
	match camera_mode:
		0:
			control_camera_1st(delta)
		1:
			control_camera_3rd(delta)
	
	input = Input.get_vector('left','right','forward','back')
	
	mouse_input = Vector2.ZERO
	
	
	if Input.is_action_just_pressed('change_view') and allow_mode_change:
		camera_mode = int(!bool(camera_mode))


func control_camera_3rd(delta : float):
	spring_arm.rotate_object_local(Vector3(1,0,0),mouse_input.y)
	spring_arm.rotate_object_local(Vector3(0,1,0),mouse_input.x)
	spring_arm.rotation.z = 0
	
	spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x,-50,50)
	spring_arm.spring_length = lerp(spring_arm.spring_length,spring_arm_len,0.1)
	
	var mw : int
	if Input.is_action_just_pressed('mw_up'):
		mw = -1
	elif Input.is_action_just_pressed('mw_dn'):
		mw = 1
		
	spring_arm_len += mw * delta * 5
	
	
func control_camera_1st(delta : float):
	#pawn.angular_velocity.y = mouse_input.x * 50
	#
	#pawn.angular_velocity.y = mouse_input.x * 50
	camera.rotate_x(mouse_input.y)
	pawn.rotate_y(mouse_input.x)
	camera.global_rotation.y = pawn.global_rotation.y
	camera.rotation.z = 0
	
	
	
	#spring_arm.rotation.y = -pawn.rotation_degrees.y

func control_pawn(delta : float):
	pass

func pawn_changed(old : Pawn):
	if old:
		spring_arm.remove_excluded_object(old.get_rid())
		
		#old.axis_lock_angular_x = false
		#old.axis_lock_angular_y = false
		#old.axis_lock_angular_z = false
	
	spring_arm.add_excluded_object(pawn.get_rid())
	pawn.axis_lock_angular_x = true
	pawn.axis_lock_angular_y = true
	pawn.axis_lock_angular_z = true
