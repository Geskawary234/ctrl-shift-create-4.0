extends Control


@onready var master: HSlider = $VBoxContainer/Master
@onready var sfx: HSlider = $VBoxContainer/Sfx
@onready var music: HSlider = $VBoxContainer/Music

var minimum_db : float = -50

func _ready() -> void:
	master.value = get_volume(0)
	sfx.value = get_volume(1)
	music.value = get_volume(2)
	
	master.value_changed.connect(master_changed)
	sfx.value_changed.connect(sfx_changed)
	music.value_changed.connect(music_changed)

func master_changed(v : float):	
	change_volume(0,v)

func sfx_changed(v : float):
	change_volume(1,v)

func music_changed(v : float):
	change_volume(2,v)

func change_volume(bus_index : int, slider_val : float):
	var vol : float = minimum_db * (1 - (slider_val/100))
	AudioServer.set_bus_volume_db(bus_index,vol)
	
func get_volume(bus_index : int):
	var vol : float = AudioServer.get_bus_volume_db(bus_index)
	var v : float
	if vol != 0:
		v = 100 - (vol/minimum_db)*100
	else:
		v = 100
	return abs(v)
