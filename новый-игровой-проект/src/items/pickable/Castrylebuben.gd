extends UsableItem

@onready var ap: AnimationPlayer = $CastrylaModel/AnimationPlayer
@onready var reload_text: Label3D = $CastrylaModel/Label3D



func main():
	super()
	if !ap.is_playing():
		$CastrylaModel/AnimationPlayer.play('bang')
		print()
	

func hit_all_roaches():
	for i in get_tree().current_scene.get_tree().get_nodes_in_group('CockroachBG'):
		i.overwhelmed = 3

func _process(delta: float) -> void:
	super(delta)
	
	if ap.is_playing():
		var k := ap.current_animation_length - ap.current_animation_position
		k = snapped(k,0.1)
		reload_text.text = str(k)
