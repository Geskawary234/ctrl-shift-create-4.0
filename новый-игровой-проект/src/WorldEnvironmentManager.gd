extends WorldEnvironment

func _ready() -> void:
	Global.GraphicsChanged.connect(setup_graphics_settings)
	setup_graphics_settings()

func setup_graphics_settings():
	environment.ssr_enabled = Global.graphics_settings['ssr']
	environment.ssil_enabled = Global.graphics_settings['ssil']
	environment.ssao_enabled = Global.graphics_settings['ssao']
	
	if Global.graphics_settings['volumetric_fog']:
		environment.volumetric_fog_density = 0.01
	else:
		environment.volumetric_fog_density = 0
	
