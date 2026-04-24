extends UsableItem

@onready var ap: AnimationPlayer = $Node3D/AnimationPlayer


func main():
	super()
	
	if !ap.is_playing():
		ap.play('clean')
