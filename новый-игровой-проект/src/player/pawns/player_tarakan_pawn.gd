extends Pawn


@onready var alert_area: Area3D = $AlertArea

func _process(delta: float) -> void:
	for b in alert_area.get_overlapping_bodies():
		b.emit_signal('increase_level',delta * 10/global_position.distance_to(b.global_position),self)
