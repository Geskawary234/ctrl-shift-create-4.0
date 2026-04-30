extends UsableItem

@onready var ap: AnimationPlayer = $CastrylaModel/AnimationPlayer



func main():
	super()
	if !ap.is_playing():
		$CastrylaModel/AnimationPlayer.play('bang')
		print()
	

func hit_all_roaches():
	for i in get_tree().current_scene.get_tree().get_nodes_in_group('CockroachBG'):
		i.overwhelmed = 5

func _process(delta: float) -> void:
	super(delta)
