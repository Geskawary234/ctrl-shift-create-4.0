extends FmodBankLoader

func _ready() -> void:
	get_buses()

func get_buses():
	Global.master_bus = FmodServer.get_bus_from_guid('{46c0fd1b-b4e8-409d-bf66-41cf1ea4d0f9}')
	Global.foley_bus = FmodServer.get_bus_from_guid('{e9e3eb05-03ea-48c8-a9c9-1666159f89e5}')
	Global.music_bus = FmodServer.get_bus_from_guid('{e7d4f363-d274-4f00-a6a4-c1fc86562390}')
	
	
	Global.master_bus.volume = Global.master_volume
	Global.music_bus.volume = Global.music_volume
	Global.foley_bus.volume = Global.sound_volume
