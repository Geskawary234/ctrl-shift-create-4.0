extends ItemWeapon

@onready var ap: AnimationPlayer = $Handheld/AnimationPlayer
@onready var slap_area: Area3D = $Handheld/tapok2/SlapArea

func main():
	if !ap.is_playing():
		ap.play('slap')
		
	

func hit_cocks():
	for i in slap_area.get_overlapping_bodies():
		i.die()
		FmodServer.play_one_shot('event:/RoachDead')
