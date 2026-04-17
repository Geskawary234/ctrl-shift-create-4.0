extends RefCounted
class_name GameServer


static func spawn(scene : PackedScene, pos : Vector3, owner : Node):
	var s = scene.instantiate()
	owner.add_child(s)
	s.global_position = pos

static func play_sound_3d(Stream : AudioStream,owner : Node3D, pos : Vector3, volume : float = 0, remove_after_play : bool = true):
	var aud : = AudioStreamPlayer3D.new()
	aud.stream = Stream
	aud.volume_db  = volume
	aud.autoplay = true
	
	if remove_after_play: aud.finished.connect(aud.queue_free)
	
	owner.add_child(aud)
	aud.global_position = pos
	
	return aud


static func interpolated_look_at(object: Node3D, target_position : Vector3,weight : float = 0.05,model_front : bool = false):
	var current_rot : = Quaternion(object.global_basis)
	
	if object.global_position != target_position:
	
		object.look_at(target_position,Vector3.UP,model_front)
		
		
	var targ_basis := object.global_basis
	var targ_rot : = Quaternion(targ_basis)
			
	var slerped : Basis = current_rot.slerp(targ_rot,weight)
	object.global_basis = slerped
			
	var facing_dot : = object.global_basis.z.dot(targ_basis.z)
	
	return facing_dot
