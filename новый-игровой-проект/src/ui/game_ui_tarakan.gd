extends Control

@onready var player_controller: Node3D = $"../../../.."
@onready var pause_manager: Node = $"../../../../PauseManager"


var runes : int = 0
@onready var runes_count_lab: Label = $RunesCount


@onready var hp_bar: ProgressBar = $hp
@onready var upgrades: Control = $Upgrades


func _process(delta: float) -> void:
	if player_controller.pawn:
		if player_controller.pawn is PlayerTarakanPawn:
			tarakan_process(delta)

func tarakan_process(delta : float):
	hp_bar.value = (player_controller.pawn.health/player_controller.pawn._health)*100
	runes_count_lab.text = 'Рун найдено:' + str(runes)
	
	
	if Input.is_action_just_pressed('upgrade_ui'):
		upgrades.show()
		pause_manager.pause_tree()
	
