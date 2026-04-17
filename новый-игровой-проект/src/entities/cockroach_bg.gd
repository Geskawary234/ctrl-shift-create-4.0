extends CharacterBody3D


var rot_dir : int = randi_range(1,-1)
var previous_normal : Vector3

func _ready() -> void:
	rotation_degrees.y = randi_range(0,360)

func _physics_process(delta: float) -> void:
	

	var col := get_last_slide_collision()
	if col:
		var normal := col.get_normal()
		
		var smooth_normal = previous_normal.lerp(normal, 5.0 * delta).normalized()
		previous_normal = smooth_normal
		
		smooth_normal = normal
		
		var basis = global_transform.basis
		basis.y = smooth_normal
		basis.x = -basis.z.cross(smooth_normal).normalized()
		basis.z = basis.x.cross(smooth_normal).normalized()
		
		global_transform.basis = basis
	
	
	velocity = -global_basis.z * 4
	
	
	#rotate_object_local(Vector3.UP,rad_to_deg(delta * rot_dir / 100))

	move_and_slide()
