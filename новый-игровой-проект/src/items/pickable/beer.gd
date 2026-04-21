extends UsableItem

@onready var ap: AnimationPlayer = $beer2/AnimationPlayer
@onready var beer_overlay: Control = $beer2/BeerOverlay
@onready var beer_prog: ProgressBar = $beer2/BeerOverlay/ProgressBar

var beer_level : int = 3

func _ready() -> void:
	super()
	in_inventory.connect(func(): beer_overlay.hide())

func main():
	super()
	if beer_level>0:
		if !ap.is_playing():
			ap.play("DrinkBeer")
	
	
	

func decrease_beer_level():
	beer_level -= 1
	beer_prog.value = beer_level

func thrown_func():
	super()
	beer_overlay.hide()
	ap.stop()

func equip():
	super()
	beer_overlay.show()

	
