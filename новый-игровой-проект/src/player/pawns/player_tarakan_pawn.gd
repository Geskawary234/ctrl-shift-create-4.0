extends Pawn
class_name PlayerTarakanPawn

@export var spring_len : float = 0.2
@export var speed : float = 0.5
@export var _health : float = 10
@onready var alert_area: Area3D = $AlertArea

signal AddRune

var health : float = _health

func _process(delta: float) -> void:
	for b in alert_area.get_overlapping_bodies():
		b.emit_signal('increase_level',delta * 3/global_position.distance_to(b.global_position),self)

func take_damage(damage : float):
	health -= damage
