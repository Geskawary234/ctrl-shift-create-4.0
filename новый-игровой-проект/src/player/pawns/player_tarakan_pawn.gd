extends Pawn
class_name PlayerTarakanPawn

@export var spring_len : float = 0.2
@export var speed : float = 0.5
@export var _health : float = 10
@onready var alert_area: Area3D = $AlertArea

@onready var ap : AnimationPlayer = $Model.get_node('AnimationPlayer')

signal AddRune

signal die

@onready var health : float = _health

func _ready() -> void:
	AddRune.connect(func(): get_tree().change_scene_to_file('res://scenes/ui/good ending.tscn'))
	die.connect(func(): get_tree().change_scene_to_file('res://scenes/ui/bad ending.tscn'))
	
func _process(delta: float) -> void:
	for b in alert_area.get_overlapping_bodies():
		b.emit_signal('increase_level',delta * 3/global_position.distance_to(b.global_position),self)

func _physics_process(delta: float) -> void:
	if linear_velocity.length()>0.01:
		ap.play('Your_Cock')
	else:
		ap.stop()

func take_damage(damage : float):
	if health - damage > 0:
		health -= damage
	else:
		print('fsfwfwf')
		die.emit()
	
