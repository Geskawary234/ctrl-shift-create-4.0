extends Area3D

@export var teleport_to : Node3D

func _ready() -> void:
	
	body_entered.connect(
		func(b):
			b.global_position = teleport_to.global_position
	)
