extends Node

var intro_played : bool = false

var GM : GameManager


var cave_music_area : FmodEventArea
# BUSES SECTION

var master_bus : FmodBus
var foley_bus : FmodBus
var music_bus : FmodBus

var master_volume : float = 1
var music_volume : float = 1
var sound_volume : float = 1

signal GraphicsChanged
var graphics_settings : Dictionary[String,bool] = {
	'ssr' : true,
	'ssao' : true,
	'ssil' : true
}


func _init() -> void:
	var data = load_settings()
	if data:
		master_volume = data['master']
		music_volume = data['music']
		sound_volume = data['sound']
		

		for s in graphics_settings.keys():
			if s in data:
				graphics_settings[s] = data[s]
		
		
	
	
	#TarakanUpgraded.connect(func(v): print(v))


func save_settings():
	var file = FileAccess.open("user://settings.cfg", FileAccess.WRITE)
	if file:
		var data = {
			'music' : music_volume,
			'sound' : sound_volume,
			'master' : master_volume,
		}
		
		for s in graphics_settings.keys():
			data[s] = graphics_settings[s]
		
		
		file.store_string(JSON.stringify(data))
		file.close()

func load_settings():
	if FileAccess.file_exists("user://settings.cfg"):
		var file = FileAccess.open("user://settings.cfg", FileAccess.READ)
		var content = file.get_as_text()
		file.close()

		var data = JSON.parse_string(content)
		if data:
			return data

# OTHER
signal TarakanUpgraded(upgrade : TarakanUpgrades)

enum TarakanUpgrades {
	Guns,
	Saw,
	Health
}

var tarakan_upgrades : Dictionary[TarakanUpgrades,int] = {
	TarakanUpgrades.Guns : 0,
	TarakanUpgrades.Saw : 0,
	TarakanUpgrades.Health : 0
}
