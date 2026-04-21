extends Control

@onready var player_controller: Node3D = $"../../../.."

var runes : int = 0
@onready var runes_count_lab: Label = $RunesCount


@onready var hp_bar: ProgressBar = $hp


func _process(delta: float) -> void:
	if player_controller.pawn:
		if player_controller.pawn is PlayerTarakanPawn:
			tarakan_process(delta)

func tarakan_process(delta : float):
	hp_bar.value = (player_controller.pawn.health/player_controller.pawn._health)*100
	runes_count_lab.text = 'Рун найдено:' + str(runes)
