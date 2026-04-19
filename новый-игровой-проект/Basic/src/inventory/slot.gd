@tool
extends Control
class_name Slot

@export var icon : Texture2D :
	set(v):
		icon = v
		$ItemTexture.texture = icon
		
		
@export var count : int :
	set(v):
		count = v
		$Count.text = str(count)

func _ready() -> void:
	$ItemTexture.texture = icon
	$Count.text = str(count)
