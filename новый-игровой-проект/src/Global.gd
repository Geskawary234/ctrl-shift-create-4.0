extends Node

var intro_played : bool = false


var master_bus : FmodBus
var ambience_bus : FmodBus
var foley_bus : FmodBus
var music_bus : FmodBus

var master_volume : float = 1
var music_volume : float = 1
var sound_volume : float = 1

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
