extends Control

@onready var rect: ColorRect = $ColorRect


func _ready() -> void:
	rect.color.a = 0

var activated : bool = false

func activate(duration : float = 1):
	if activated: return

	activated = true
	
	var t := create_tween()
	t.tween_property(rect,'color',Color(0,0,0,1),0.5)
	await t.finished
	
	await get_tree().create_timer(duration,false).timeout
	
	t = create_tween()
	t.tween_property(rect,'color',Color(0,0,0,0),0.5)
	await t.finished
	
	activated = false
