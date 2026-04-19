extends Node

var intro_played : bool = false


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
