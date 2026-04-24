extends FmodEventArea

signal fight

func _ready():
	super()
	Global.cave_music_area = self
	
	fight.connect(func(): event.set_parameter_by_name('Fight',1))

func exited(_b):
	super(_b)

func entered(_b):
	super(_b)
	
	event.set_parameter_by_name('Fight',0)
