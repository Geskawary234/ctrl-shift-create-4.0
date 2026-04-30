extends Pawn
class_name PlayerTarakanPawn

@export var spring_len : float = 0.2
@export var speed : float = 0.5
@export var _health : float = 10
@export var look_light : Light3D

@onready var alert_area: Area3D = $AlertArea

@onready var ap : AnimationPlayer = $Model.get_node('AnimationPlayer')

@onready var minigun_1: Weapon = $Weapons/Minigun1
@onready var minigun_2: Weapon = $Weapons/Minigun2

var press_e_to_skip_night : bool = false


signal AddRune

signal die

@onready var health : float = _health

func _ready() -> void:
	die.connect(func(): Global.GM.sleep())
	
	minigun_1.deployed = false
	minigun_2.deployed = false
	minigun_1.targeting_area.active = false
	minigun_2.targeting_area.active = false
	
	Global.TarakanUpgraded.connect(
		func(v : Global.TarakanUpgrades): 
			if v == Global.TarakanUpgrades.Guns:
				var level : int = Global.tarakan_upgrades[Global.TarakanUpgrades.Guns]

				if level == 1:
					minigun_1.deployed = true
					minigun_1.targeting_area.active = true
				elif level == 2:
					minigun_2.deployed = true
					minigun_2.targeting_area.active = true
				
				
			
			
			)
	
func _process(delta: float) -> void:
	for b in alert_area.get_overlapping_bodies():
		if b.has_signal('increase_level'):
			b.emit_signal('increase_level',delta * 3/global_position.distance_to(b.global_position),self)
	
	if press_e_to_skip_night:
		if Input.is_action_just_pressed('interact'):
			Global.GM.sleep()
	
	
func _physics_process(delta: float) -> void:
	if linear_velocity.length()>0.01:
		ap.play('Your_Cock')
	else:
		ap.stop()

func take_damage(damage : float):
	if health - damage > 0:
		health -= damage
	else:
		die.emit()
	
