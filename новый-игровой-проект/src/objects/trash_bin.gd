extends Node3D

var objects_in_bin : Dictionary[Variant,float]

@onready var garbage_area: Area3D = $GarbageArea
@onready var filled_up_area: Area3D = $FilledUpArea

func _ready() -> void:
	garbage_area.body_entered.connect(get_all_bodies)
	garbage_area.body_exited.connect(get_all_bodies)
	filled_up_area.body_entered.connect(get_all_bodies)
	filled_up_area.body_exited.connect(get_all_bodies)
	
func get_all_bodies(b : Variant):
	var detected = garbage_area.get_overlapping_bodies() + filled_up_area.get_overlapping_bodies()
	
	for i in objects_in_bin:
		if i not in detected:
			objects_in_bin.erase(i)
	
	for i in detected:
		if i not in objects_in_bin:
			objects_in_bin[i] = 5

func _process(delta: float) -> void:
	for i in objects_in_bin.keys():
		objects_in_bin[i] -= delta
		objects_in_bin[i] = clamp(objects_in_bin[i],0,INF)

			
			
