extends Marker3D
class_name Spawner

@export var scene : PackedScene
@export var spawn_owner : Node

func spawn(count : int, position_offset_range : float = 0,rotation_offset_range : float = 0):
	
	var sowner : Node
	if spawn_owner:
		sowner = spawn_owner
	else:
		sowner = self

	for i in range(count):
		
		var offset_v : Vector3 = Vector3.ZERO
		if position_offset_range:
		
			offset_v.x = randf_range(-position_offset_range,position_offset_range)
			offset_v.z = randf_range(-position_offset_range,position_offset_range)
		
		 
		var obj = GameServer.spawn(scene,global_position + offset_v,sowner)
		obj.rotate_object_local(Vector3.UP,deg_to_rad(randf_range(-rotation_offset_range,rotation_offset_range)))
