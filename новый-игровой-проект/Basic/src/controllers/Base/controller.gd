extends Node3D
class_name Controller

signal pw_changed(old : Pawn)


@export var pawn : Pawn :
	set(p):
		var old : Pawn = pawn
		pawn = p
		pw_changed.emit(old)
		
		
		


func _ready() -> void:
	pw_changed.connect(pawn_changed)
	
	if pawn:
		pawn_changed(null)

func _process(delta: float) -> void:
	if pawn:
		pawn_process(delta)

func _physics_process(delta: float) -> void:
	if pawn:
		pawn_physics_process(delta)

func pawn_process(delta : float):
	pass

func pawn_physics_process(delta : float):
	pass

func follow_pawn():
	global_position = global_position.lerp(pawn.global_position,1)

func pawn_changed(old : Pawn):
	pass
