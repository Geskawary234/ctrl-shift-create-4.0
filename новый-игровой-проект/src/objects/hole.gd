extends Node3D
class_name SpawnHole

@export var teleport_to : Node3D

@onready var t_area: Area3D = $Area3D

func _ready() -> void:
	t_area.body_entered.connect(func(b):
		if b is not PlayerTarakanPawn: return
		
		b.global_position = teleport_to.global_position
		)

	
