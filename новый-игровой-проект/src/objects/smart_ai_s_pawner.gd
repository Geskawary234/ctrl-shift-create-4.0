extends Node3D


func spawn():
	k = count
	main()


var count : int = 10
var spawn_scene : PackedScene = preload("uid://c3ujlv30r8egx")
@export var spawn_time : float = 0.1
@export var spawn_owner : Node = self

var k : int
func main():
	if k>0: k-=1
	else: return
	
	await get_tree().create_timer(spawn_time,false).timeout
	var c = GameServer.spawn(spawn_scene,global_position,spawn_owner)
	c.global_rotation_degrees.y = randi_range(0,360)
	main()
