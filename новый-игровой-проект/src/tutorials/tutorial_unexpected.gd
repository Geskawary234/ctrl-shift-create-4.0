@tool
extends TutorialNode

var f : bool = false
func _ready() -> void:
	super()
	
	$"../../Sounds/DoorDialog2".finished.connect(
		func():
			await get_tree().create_timer(15,false).timeout.connect(func(): setup_next.emit())
			

		
	)
	
	finished.connect(
		func(): 
			if f: return
			await get_tree().create_timer(2,false).timeout
			setup_next.emit()
			)
