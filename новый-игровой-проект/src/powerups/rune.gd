@tool
extends Node3D


@export_enum('rune1','rune2','rune3','rune4','rune5','rune6') var rune_type = 0:
	set(v):
		var runes : Array[Texture2D] = [
			preload('res://assets/textures/runes/rune1.jpg'),
			preload('res://assets/textures/runes/rune2.jpg'),
			preload('res://assets/textures/runes/rune3.jpg'),
			preload('res://assets/textures/runes/rune4.jpg'),
			preload("res://assets/textures/runes/rune5.jpg"),
			preload('res://assets/textures/runes/rune6.jpg')
		]
		var rune_1_scale : Vector3 = Vector3(0.13,0.21,0.13)
		var other_runes_scale : Vector3 = Vector3(0.2,0.16,0.13)
		
		rune_type = v
		var mat : StandardMaterial3D = $MeshInstance3D.get_active_material(0)
		mat.albedo_texture = runes[v]
		
		if v == 0:
			$MeshInstance3D.scale = rune_1_scale
		else:
			$MeshInstance3D.scale = other_runes_scale
		

func _ready() -> void:
	$Area3D.body_entered.connect(player_entered)
	if !Engine.is_editor_hint():
		rune_type = randi_range(0,5)

func player_entered(b):
	b.AddRune.emit()
	queue_free()
	

@onready var mesh: MeshInstance3D = $MeshInstance3D
var t : float
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		mesh.rotate_object_local(Vector3.UP,delta)
		t += delta * 5
		mesh.position.y = sin(t) * delta + 0.05
