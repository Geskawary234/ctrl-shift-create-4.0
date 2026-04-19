extends Node3D


func _ready() -> void:
	main()


var k : int = 50
const COCKROACHES_SMART_TEST = preload('res://scenes/entites/cockroach_bg.tscn')
func main():
	if k>0: k-=1
	else: return
	
	await get_tree().create_timer(0.01,false).timeout
	var c = GameServer.spawn(COCKROACHES_SMART_TEST,global_position,self)
	c.global_rotation_degrees.y = randi_range(0,360)
	main()
