extends Control


@onready var master: HSlider = $VBoxContainer/Master
@onready var sfx: HSlider = $VBoxContainer/Sfx
@onready var music: HSlider = $VBoxContainer/Music


var minimum_db : float = -50

var master_bus : FmodBus
var foley_bus : FmodBus
var music_bus : FmodBus
# {46c0fd1b-b4e8-409d-bf66-41cf1ea4d0f9} - master bus

func _ready() -> void:
	
	master_bus = Global.master_bus
	foley_bus = Global.foley_bus
	music_bus = Global.music_bus

	
	master.value = master_bus.volume * 100
	sfx.value = foley_bus.volume * 100
	music.value = music_bus.volume * 1000
	
	master.value_changed.connect(master_changed)
	sfx.value_changed.connect(sfx_changed)
	music.value_changed.connect(music_changed)
	
func master_changed(v : float):	
	#change_volume(0,v)
	master_bus.volume = v/100
	Global.master_volume = v/100
	
func sfx_changed(v : float):
	foley_bus.volume = v/100
	Global.sound_volume = v/100

func music_changed(v : float):
	music_bus.volume = v/100
	Global.music_volume = v/100

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
