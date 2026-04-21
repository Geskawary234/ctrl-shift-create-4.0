extends DraggableItem
class_name Bed


@export var bed_cooldown : float = 30

func _process(delta: float) -> void:
	if bed_cooldown>0:
		bed_cooldown -= delta
		bed_cooldown = clamp(bed_cooldown,0,INF)
		bed_cooldown = snapped(bed_cooldown,0.01)
