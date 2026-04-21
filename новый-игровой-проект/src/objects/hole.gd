extends Node3D
class_name SpawnHole

@onready var cock_spawner: Node3D = $Decal/CockSpawner
@export var teleport_to : Node3D

@onready var t_area: Area3D = $Area3D

func _ready() -> void:
	t_area.body_entered.connect(func(b):
		if b is not PlayerTarakanPawn: return
		
		b.global_position = teleport_to.global_position
		)



func spawn_cocks(count,time,spawn_owner):
	'''
	if cock_spawner.spawn_owner:
		for i in cock_spawner.spawn_owner.get_children():
			i.queue_free()'''
	
	cock_spawner.count = count
	cock_spawner.spawn_time = time
	cock_spawner.spawn_owner = spawn_owner
	cock_spawner.spawn()
	

	
