extends Node3D

@onready var cocroch_ap : AnimationPlayer = $"../cocroch".get_node('AnimationPlayer')


func _process(delta: float) -> void:
	$"../cocroch".rotate_y(delta * 5)
	
	if !cocroch_ap.is_playing(): cocroch_ap.play('2_Walk_Fix_001')
