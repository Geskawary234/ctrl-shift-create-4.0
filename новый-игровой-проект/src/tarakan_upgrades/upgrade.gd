@tool
extends Control

@export var texture : Texture2D :
	set(v):
		texture = v
		$IconContent/TextureRect.texture = v

@export var locked : bool = false :
	set(v):
		locked = v
		if v:
			$IconContent.modulate = Color.RED
		else:
			$IconContent.modulate = Color.WHITE
