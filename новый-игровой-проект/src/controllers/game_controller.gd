extends PlayerController

@export var rc : RayCast3D

@onready var tarakan := $"../Tarakan"
@onready var player_pawn := $"../Pawn"


func _process(delta: float) -> void:
	super(delta)
	
	if Input.is_action_just_pressed('e'):
		
		allow_mode_change = true
		
		if pawn == player_pawn:
			
			pawn = tarakan
			camera_mode = 1
			camera.position = Vector3.ZERO
		else:
			pawn = player_pawn
			camera.position = Vector3(0,0.5,0)
			camera_mode = 0
			
		allow_mode_change = false

var heavy_item : Item
var item_held_pos : Vector3
func pawn_process(delta: float) -> void:
	super(delta)
	
	if Input.is_action_pressed('lmb'):
		if rc.is_colliding() and !heavy_item:
			var col := rc.get_collider()
			if col is Item:
				heavy_item = rc.get_collider()
				item_held_pos = heavy_item.to_local(rc.get_collision_point())
	else:
		heavy_item = null
	if heavy_item:
		process_heavy_item()


var damping := 10
var power := 5
func process_heavy_item():
	var tpos : = -camera.global_basis.z*2 + camera.global_position
	
	
	var dir : Vector3 = tpos - heavy_item.to_global(item_held_pos)
	var ndir : Vector3 = dir.normalized()
	var force = ndir * 10
	
	if dir.length()<1:
		force *= dir.length()/1
		
	
	
	heavy_item.apply_force(force,item_held_pos)
	
	heavy_item.angular_velocity = heavy_item.angular_velocity.clamp(Vector3.ZERO,Vector3.ONE)

		
