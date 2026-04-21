extends Node
class_name GameManager


@onready var hole_position: PathFollow3D = $HoleTrajectory/HolePosition
@onready var hole: SpawnHole = $HoleTrajectory/HolePosition/Hole
@onready var nest: Node3D = $"../Background assets/nest"

@onready var start_camera: Camera3D = $StartCamera
@export var bg_music : FmodEventEmitter3D
@export var player_controller : PlayerController

@export var human_pawn : PlayerHumanPawn
@export var tarakan_pawn : PlayerTarakanPawn

@export var enable_tutorial : bool = true
@export var tutorials : Array[TutorialNode]
var current_tutorial : int = 0

@export var smart_ai_spawners : Array[Node3D]

@export var roach_infestation_level : float = 0
@export var number_of_days : int = 7
@export var current_day : int = 1 :
	set(v):
		if current_day+v < number_of_days:
			current_day += v
			current_day = clamp(current_day,0,number_of_days)


var human_tarakan_kill_count : int = 0


enum datetime {
	Day,
	Night
}
@export_enum('Day','Night') var time_of_the_day : int :
	set(v):
		time_of_the_day = v


func _ready() -> void:
	Global.GM = self
	
	get_away_pawn(tarakan_pawn,Vector3.ZERO + Vector3(0,5,0))
	
	for t in tutorials:
		t.setup_next.connect(set_next_tutorial)
	
	if !enable_tutorial:
		$"../Sounds/KnockKnock".play()
		$"../Sounds/StopKnocking".enable = true
		$"../Sounds/DoorDialog2".enable = true
		
	start_camera.cutscene()
	
	new_day()
	


# VISUAL AND AUDIO CHANGE 
func set_music_value(v):
	if bg_music:
		bg_music.set_parameter('Parameter 2',v)
		
@onready var light: DirectionalLight3D = $"../DirectionalLight3D"
@onready var env: Environment = $"../WorldEnvironment".environment
func set_environment():
	match time_of_the_day:
		datetime.Night:
			env.background_energy_multiplier = 0
			env.ambient_light_energy = 0.1
			light.light_energy = 0
		datetime.Day:
			env.background_energy_multiplier = 1.5
			env.ambient_light_energy = 0.3
			light.light_energy = 1
	
# GETS CALLED AFTER THE NIGHT IS FINISHED
@onready var bg_tarakans_node: Node = $BgTarakansNode

func new_day():
	get_away_pawn(tarakan_pawn,Vector3.ZERO + Vector3(0,5,0))
	
	time_of_the_day = datetime.Day
	
	set_environment()
	set_music_value(time_of_the_day)
	
	if human_tarakan_kill_count>=5:
		add_infestation_level(-10)
		human_tarakan_kill_count = 0
	
	hole_position.progress_ratio = randf()
	hole.spawn_cocks(50,0.1,bg_tarakans_node)


var going_to_sleep : bool = false
const TARAKAN_AI = preload("res://scenes/entites/tarakan_ai.tscn")
func go_to_sleep():
	if going_to_sleep: return
	if time_of_the_day != datetime.Day: return
	going_to_sleep = true
	
	if current_day == 1:
		$"../Sounds/StopKnocking".enable = false
		$"../Sounds/DoorDialog2".enable = false
	
	
	await get_tree().create_timer(0.5,false).timeout
	
	time_of_the_day = datetime.Night
	set_environment()
	set_music_value(time_of_the_day)
	
	
	for i in bg_tarakans_node.get_children():
		i.queue_free()
	
	add_pawn(tarakan_pawn)
	player_controller.pawn = tarakan_pawn
	get_away_pawn(human_pawn)
	
	
	var spawn_p : Vector3 = hole.global_basis.x + hole.global_position
	
	for i in range(randi_range(10,20)):
		
		var random_v : Vector3
		random_v.x = randf_range(-0.5,0.5)
		random_v.z = randf_range(-0.5,0.5)
		
		GameServer.spawn(TARAKAN_AI,spawn_p + random_v,bg_tarakans_node)
	
	
	nest.show()
	for s in smart_ai_spawners:
		s.spawn()
	
	
	for i in range(0,3):
		tutorials[i].queue_free()
	
	tutorials[4].appear.emit()
	tutorials[4].start_filling.emit()
	going_to_sleep = false



#TUTORIAL
func set_next_tutorial():
	
	if current_tutorial + 1 > len(tutorials) - 1: return
	else:
		tutorials[current_tutorial].hide()
		
		current_tutorial += 1
		
		if current_tutorial == 4: return
		
		tutorials[current_tutorial].appear.emit()
		tutorials[current_tutorial].start_filling.emit()


func add_infestation_level(amount : float):
	roach_infestation_level += amount
	roach_infestation_level = clamp(roach_infestation_level,0,100)


#FmodServer.get_event_from_guid(bg_music.event_guid).release_all_instances()

func _process(delta: float) -> void:
	if tarakan_pawn.global_position.y<-1:
		tarakan_pawn.global_position = $"../Background assets/nest/teleportTo".global_position

func get_away_pawn(pawn : Pawn, pos : Vector3 = Vector3.ZERO):
	pawn.global_position = pos
	pawn.set_process(false)
	pawn.set_physics_process(false)
	pawn.hide()

func add_pawn(pawn : Pawn, pos : Vector3 = Vector3.ZERO):
	pawn.global_position = pos
	pawn.set_process(true)
	pawn.set_physics_process(true)
	pawn.show()
