extends DraggableItem
class_name Bed


@export var bed_cooldown : float = 30
@onready var end_night_shift: Area3D = $EndNightShift

func _ready() -> void:
	end_night_shift.body_entered.connect(func(b):
		if b is PlayerTarakanPawn:
			b.press_e_to_skip_night = true
		
		)
	
	end_night_shift.body_exited.connect(func(b):
		if b is PlayerTarakanPawn:
			b.press_e_to_skip_night = false
		
		)


func _process(delta: float) -> void:
	if bed_cooldown>0:
		bed_cooldown -= delta
		bed_cooldown = clamp(bed_cooldown,0,INF)
		bed_cooldown = snapped(bed_cooldown,0.01)
