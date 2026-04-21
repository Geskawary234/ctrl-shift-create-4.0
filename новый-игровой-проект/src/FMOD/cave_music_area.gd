extends FmodEventArea

signal fight

func _ready():
	super()
	Global.cave_music_area = self
	
	fight.connect(func(): event.set_parameter_by_name('Fight',1))
