extends Camera3D
class_name CutsceneCamera

@export var GM : GameManager

@export var disable_cutscene : bool = false

func _ready() -> void:
	if disable_cutscene: queue_free()
	
func cutscene():
	if disable_cutscene:
		if GM.enable_tutorial:
			GM.tutorials[0].appear.emit()
			GM.tutorials[0].start_filling.emit()
		queue_free()
		return
	else:
		
		GM.player_controller.pawn.hide()
		
		await get_tree().create_timer(1,false).timeout
		
		var t := create_tween()
		t.tween_property(self,'rotation_degrees',Vector3(30,180,0),1)
		
		await t.finished
		
		await get_tree().create_timer(0.2,false).timeout
		
		FmodServer.play_one_shot('event:/Seat')
		
		t = create_tween()
		t.set_parallel(true)
		t.tween_property(self,'global_position',GM.player_controller.camera.global_position,1)
		t.tween_property(self,'rotation_degrees',Vector3(0,180,0),1)
		await t.finished
		
		GM.player_controller.pawn.show()

		current = false
		
		if GM.enable_tutorial:
			GM.tutorials[0].appear.emit()
			GM.tutorials[0].start_filling.emit()
		queue_free()
	
