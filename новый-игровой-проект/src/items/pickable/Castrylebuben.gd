extends ItemWeapon

@onready var ap: AnimationPlayer = $CastrylaModel/AnimationPlayer


func main():
	super()
	if !ap.is_playing():
		$CastrylaModel/AnimationPlayer.play('bang')
	

func hit_all_roaches():
	for i in get_tree().current_scene.get_tree().get_nodes_in_group('CockroachBG'):
		i.overwhelmed = 3
