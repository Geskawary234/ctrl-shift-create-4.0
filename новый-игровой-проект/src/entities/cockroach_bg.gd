extends CharacterBody3D

var normal_changed : float = 0
var cant_go_normals : Array
var prev_position : Vector3
var a : float = 0
var overwhelmed : float = 0
func _physics_process(delta: float) -> void:
	if overwhelmed<=0:
		velocity = -global_basis.z * 3
	else:
		velocity = Vector3.ZERO
		overwhelmed -= delta
		
	move_and_slide()
	var col := get_last_slide_collision()
	
	if col and normal_changed<=0:
		var n := col.get_normal()

		look_at(n + global_position)
		rotation_degrees.x = 0
		rotation_degrees.z = 0
		rotate_object_local(Vector3.UP,deg_to_rad(randf_range(-45,45)))
		
		normal_changed = 0.2
		prev_position = global_position

		
		
	normal_changed -= delta
	
const DEAD_TARAKAN = preload("uid://p7nrccetqxew")
func die():
	GameServer.spawn(DEAD_TARAKAN,global_position,get_tree().current_scene)
	queue_free()
