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




# OTHER

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
