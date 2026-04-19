extends Camera3D
@onready var player_controller: Node3D = $"../PlayerController"

@export var disable_cutscene : bool = false

func _ready() -> void:
	if disable_cutscene: queue_free()
	else: cutscene()
		
	
func cutscene():
	$"../Pawn".hide()
	
	await get_tree().create_timer(1,false).timeout
	
	var t := create_tween()
	t.tween_property(self,'rotation_degrees',Vector3(30,180,0),1)
	
	await t.finished
	
	await get_tree().create_timer(0.2,false).timeout
	
	t = create_tween()
	t.set_parallel(true)
	t.tween_property(self,'global_position',player_controller.camera.global_position,1)
	t.tween_property(self,'rotation_degrees',Vector3(0,180,0),1)
	await t.finished
	
	$"../Pawn".show()

	current = false
	queue_free()
	
