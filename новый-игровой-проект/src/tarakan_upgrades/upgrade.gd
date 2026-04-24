@tool
extends Control

@onready var btn : Button = $IconContent/Button

@export var texture : Texture2D :
	set(v):
		texture = v
		$IconContent/TextureRect.texture = v

@export var locked : bool = false :
	set(v):
		locked = v
		if v:
			$IconContent.modulate = Color.RED
			$IconContent/Button.disabled = true
		else:
			$IconContent.modulate = Color.WHITE
			$IconContent/Button.disabled = false

@export var purchased : bool = false :
	set(v):
		purchased = v
		
		if purchased:
			btn.disabled = true
			$IconContent.modulate = Color.GREEN
		else:
			btn.disabled = false
			$IconContent.modulate = Color.WHITE
