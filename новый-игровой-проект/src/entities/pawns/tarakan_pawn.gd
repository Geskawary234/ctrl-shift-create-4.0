extends Pawn
class_name TarakanPawn

signal increase_level(v : float, player_pawn : Pawn)
signal set_state(state : int)
signal set_speaking_time(value : float)
signal set_partner(p : TarakanPawn)

var health : float = 20
var max_health : float = 20
@onready var health_bar: ProgressBar = $"HealthBar/SubViewport/Control/health bar"
@onready var health_sprite: Sprite3D = $HealthBar


var speaking : bool = false

func take_damage(dmg : float, attacker : Pawn):
	if health - dmg < 0:
		die()
	else:
		health -= dmg

	health_bar.value = (health/max_health) * 100
	health_sprite.show()
	
	
	increase_level.emit(100,attacker)
	

func die():
	FmodServer.play_one_shot('event:/RoachDead')
	Global.GM.add_infestation_level(-3)

	queue_free()
	
