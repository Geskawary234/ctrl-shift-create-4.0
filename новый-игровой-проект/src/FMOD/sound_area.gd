extends Area3D
class_name SoundArea

@export var enable : bool
enum AreaType {
	PlaySound,
	StopSound
}
@export_enum('Play sound','Stop sound') var area_type : int = 0
@export var sound : FmodEventEmitter3D

signal finished

var action_happened : bool = false
func _ready() -> void:
	body_entered.connect(func(b):
		if !enable: return
		if action_happened: return

		
		if area_type == AreaType.PlaySound:
			sound.play(false)
		if area_type == AreaType.StopSound:
			sound.volume = 0
		
		action_happened = true
		finished.emit()
		)
