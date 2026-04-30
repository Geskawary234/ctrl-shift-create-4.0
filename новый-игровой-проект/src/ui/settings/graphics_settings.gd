extends Control


@onready var ssr_box: CheckButton = $VBoxContainer/SSR
@onready var ssil_box: CheckButton = $VBoxContainer/SSIL
@onready var ssao_box: CheckButton = $VBoxContainer/SSAO
@onready var volumetric_fog_box: CheckButton = $VBoxContainer/VolumetricFog



func _ready() -> void:
	ssr_box.button_pressed = Global.graphics_settings['ssr']
	ssil_box.button_pressed = Global.graphics_settings['ssil']
	ssao_box.button_pressed = Global.graphics_settings['ssao']
	volumetric_fog_box.button_pressed = Global.graphics_settings['volumetric_fog']
	
	volumetric_fog_box.pressed.connect(
		func():
			Global.graphics_settings['volumetric_fog'] = volumetric_fog_box.button_pressed
			Global.GraphicsChanged.emit()
	)
	
	ssr_box.pressed.connect(
		func():
			Global.graphics_settings['ssr'] = ssr_box.button_pressed
			Global.GraphicsChanged.emit()
	)
	
	ssil_box.pressed.connect(
		func():
			Global.graphics_settings['ssil'] = ssil_box.button_pressed
			Global.GraphicsChanged.emit()
	)
	
	ssao_box.pressed.connect(
		func():
			Global.graphics_settings['ssao'] = ssao_box.button_pressed
			Global.GraphicsChanged.emit()
	)
	
