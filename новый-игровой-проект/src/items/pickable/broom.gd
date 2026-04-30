extends UsableItem

@onready var ap: AnimationPlayer = $Node3D/AnimationPlayer


func main():
	super()
	
	if !ap.is_playing():
		ap.play('clean')
		
@onready var ar: Area3D = $Node3D/broom2/Area3D

func _process(delta: float) -> void:
	super(delta)
	if ap.is_playing():
		for b in ar.get_overlapping_bodies():
			b.die()
			FmodServer.play_one_shot('event:/RoachDead')
