extends Area3D

@export var active : bool
@export var damage_timer : float
@export var light : Light3D


var dmg_tmr : float = 0


@onready var sfx: FmodEventEmitter3D = $FmodEventEmitter3D
func _process(delta: float) -> void:
	if dmg_tmr<=0:
		var bds = get_overlapping_bodies()
		if len(bds)>0:
			light.light_energy = 1
			sfx.play(false)
		for i in bds:
			if i is TarakanPawn:
				i.take_damage(1,Global.GM.tarakan_pawn)
		
		dmg_tmr = damage_timer
	else:
		dmg_tmr -= delta
		light.light_energy = 0
		
