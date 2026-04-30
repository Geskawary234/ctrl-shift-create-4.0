extends Node
class_name GameManager

signal tarakan_killed
signal time_changed

@export var player_controller : PlayerController

@export var human_pawn : PlayerHumanPawn
@export var tarakan_pawn : PlayerTarakanPawn

@onready var hole_position: PathFollow3D = $"../HoleTrajectory/HolePosition"
@onready var bg_tarakan_spawner: Spawner = $"../HoleTrajectory/HolePosition/Hole/TarakanSpawner"
@onready var smart_tarakan_spawner: Spawner = $"../HoleTrajectory/HolePosition/Hole/SmartTarakanSpawner"
@onready var rune_spawns: Array = $"../Background assets/nest/RuneSpawns".get_children()


@export var roach_infestation_level : float = 0
@export var number_of_days : int = 7
@export var current_day : int = 1

enum datetime {
	Day,
	Night
}
@export_enum('Day','Night') var time_of_the_day : int :
	set(v):
		time_of_the_day = v

@onready var knock_knock: FmodEventEmitter3D = $"../FmodBankManager/Sounds/KnockKnock"
@onready var knock_stop_area: Area3D = $"../FmodBankManager/Sounds/KnockKnock/Area3D"
@onready var door_dialog: FmodEventEmitter3D = $"../FmodBankManager/Sounds/DoorDialog"
func _ready() -> void:
	Global.GM = self
	
	#play_knocking()
	#knock_stop_area.monitoring = true
	
	knock_stop_area.body_entered.connect(
		func(b):
			knock_knock.stop()
			door_dialog.play()
			knock_stop_area.set_deferred('monitoring',false)
			)

	time_changed.connect(
		func():
			knock_knock.stop()
			door_dialog.stop()
			knock_stop_area.set_deferred('monitoring',false)
	)
	
	tarakan_killed.connect(func(): add_infestation_level(-1))
	
	get_away_pawn(tarakan_pawn)
	
	new_day(true)


func play_knocking():
	if knock_stop_area.monitoring:
		knock_knock.play_one_shot()
		await get_tree().create_timer(randf_range(2,10),false).timeout
		play_knocking()

	return


func add_infestation_level(amount : float):
	roach_infestation_level += amount
	roach_infestation_level = clamp(roach_infestation_level,0,100)
	'''
	if roach_infestation_level>=100:
		get_tree().change_scene_to_file('res://scenes/ui/bad ending.tscn')
	
	
	if roach_infestation_level<=0:
		get_tree().change_scene_to_file('res://scenes/ui/good ending.tscn')'''
	


func new_day(first_day : bool = false):
	#await get_tree().create_timer(3,false).timeout
	
	
	
	hole_position.progress_ratio = randf()
	
	for i in get_tree().get_nodes_in_group('SmartRoach'):
		i.queue_free()
	for i in get_tree().get_nodes_in_group('Runes'):
		i.queue_free()
	
	var spawn_count : int = int(roach_infestation_level/5)
	if spawn_count>0:
		bg_tarakan_spawner.spawn(spawn_count,0,45)
	
	
	if !first_day: add_infestation_level(randi_range(5,15))

const RUNE = preload("uid://cbkgchds18sb7")
@onready var smart_tarakan_spawns: Node = $"../Background assets/nest/SmartTarakanSpawns"
func new_night():
	# + get_tree().get_nodes_in_group('TarakanItem')
	for i in get_tree().get_nodes_in_group('CockroachBG'):
		i.queue_free()
				
	smart_tarakan_spawner.spawn(int(roach_infestation_level/8),1.0)
	
	for i in smart_tarakan_spawns.get_children():
		i.spawn(int(roach_infestation_level/10))
	
	var rune_spawn : Node3D = rune_spawns.pick_random()
	GameServer.spawn(RUNE,rune_spawn.global_position,rune_spawn)
	
	

@onready var env: Environment = $"../WorldEnvironment".environment
@onready var sun: DirectionalLight3D = $"../DirectionalLight3D"
@onready var home_music: FmodEventArea = $"../FmodBankManager/Sounds/HomeMusic"
func setup_environment():
		
		match time_of_the_day:
			datetime.Day:
				sun.light_energy = 1
				env.background_energy_multiplier = 1.5
				env.ambient_light_energy = 0.3
			datetime.Night:
				sun.light_energy = 0
				env.background_energy_multiplier = 0
				env.ambient_light_energy = 0.04
		

		var h_event : FmodEvent
		if !h_event:
			await get_tree().process_frame
			h_event = home_music.event
			h_event.set_parameter_by_name('Parameter 2',time_of_the_day)


var sleep_processing : bool = false
func sleep():
	if sleep_processing: return

	sleep_processing = true
	player_controller.black_screen.activate()
	await get_tree().create_timer(0.5,false).timeout
	match time_of_the_day:
		datetime.Day:
			time_of_the_day = datetime.Night
			
			new_night()
				
			add_pawn(tarakan_pawn,Vector3.ZERO + Vector3(0,0.1,0))
			player_controller.pawn = tarakan_pawn
			get_away_pawn(human_pawn,Vector3.ZERO)
			
		datetime.Night:
			time_of_the_day = datetime.Day
			tarakan_pawn.health = tarakan_pawn._health
			
			add_pawn(human_pawn)
			player_controller.pawn = human_pawn
			
			get_away_pawn(tarakan_pawn,Vector3(0,5,0))
			
			new_day()
			
			if current_day+1 >= number_of_days:
				if roach_infestation_level>=50:
					get_tree().change_scene_to_file('res://scenes/ui/bad ending.tscn')
				else:
					get_tree().change_scene_to_file('res://scenes/ui/good ending.tscn')
			else:
				current_day += 1
			
			
	
	time_changed.emit()
	setup_environment()
	sleep_processing = false

func get_away_pawn(pawn : Pawn, pos : Vector3 = Vector3.ZERO):
	pawn.global_position = pos
	pawn.hide()
	pawn.set_process(false)
	pawn.set_physics_process(false)
	

func add_pawn(pawn : Pawn, pos : Vector3 = Vector3.ZERO):
	pawn.set_process(true)
	pawn.set_physics_process(true)
	pawn.global_position = pos
	pawn.show()
	
	
