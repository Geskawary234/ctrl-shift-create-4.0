extends Node3D


func _ready() -> void:
	main()


var k : int = 0
const COCKROACH_BG = preload("uid://bwloayysdnh25")
func main():
	if k>0: k-=1
	else: return
	print(k)
	
	await get_tree().create_timer(0.4,false).timeout
	GameServer.spawn(COCKROACH_BG,global_position,self)

	main()
