extends Controller


var alert_level : float    # alert level from 0 to 100, when it reaches
						   # 100, cockroach gets into attacking state
@onready var alert_others_area: Area3D = $"../AlertOthersArea"
var target : Pawn	
		
# thinking
var delta_accum : float = 0
var think_time : float = 0.2
var think_timer : float

# combat

var speed : float = 3
var state : States 
enum States {
	Idle,
	Walking,
	Suspecting,
	Attacking,
	Dancing
}

@onready var prog_bar_view: Sprite3D = $"../ProgBarView"
@onready var lamp_progress: TextureProgressBar = $"../ProgBarView/SubViewport/Control/LampProgress"
@onready var alerted_sprite: Sprite3D = $"../AlertedSprite"

func _ready() -> void:
	super()
	dir = Vector3(randf() * [-1,1].pick_random(),0,randf() * [-1,1].pick_random())
	
	# this lambda is connected to pawn when it recieves signal from area
	# alert level increases and state is changed to suspecting state
	pawn.increase_level.connect(func(v : float, player_pawn : Pawn):
		
		if alert_level<100:
		
			prog_bar_view.show()
			state = States.Suspecting
			
			alert_level += v
			alert_level = clamp(alert_level,0,100)
			if alert_level>=100:
				state = States.Attacking
				
				for t in alert_others_area.get_overlapping_bodies():
					t.emit_signal('increase_level',100,target)
			
			if player_pawn:
				target = player_pawn
			
			if target:
				GameServer.interpolated_look_at(pawn,target.global_position)
			lamp_progress.value = alert_level
		
		
		
		)



var dir : Vector3
var walk_time : float = 0 # for how long cockroaches goes in "dir" direction
func pawn_process(delta : float):
	super(delta)
	if think_timer<=0:
		think(delta_accum)
		think_timer = think_time
	else:
		think_timer -= delta
		delta_accum += delta

# cockroach thinks every few moments
func think(delta_accum : float):
	
	match state:
		States.Idle:
			pawn.linear_velocity.x = 0
			pawn.linear_velocity.z = 0
			
			
			if randi_range(0,5) == 0:
				walk_time = randf_range(0.2,1)
				dir = Vector3(randf() * [-1,1].pick_random(),0,randf() * [-1,1].pick_random())
				state = States.Walking
				
		States.Walking:
			pawn.linear_velocity.x = dir.x * speed
			pawn.linear_velocity.z = dir.z * speed
			
			pawn.look_at(pawn.global_position + dir)
			
			
			if walk_time>0:
				walk_time -= delta_accum
			else:
				state = States.Idle
		
		States.Suspecting:
			pawn.linear_velocity.x = 0
			pawn.linear_velocity.z = 0
			
			state = States.Idle
			prog_bar_view.hide()
		
		States.Attacking:
			prog_bar_view.hide()
			alerted_sprite.show()
		
			pawn.look_at(target.global_position)
			
			dir = -(global_position - target.global_position).normalized()
			
			pawn.linear_velocity.x = dir.x * speed
			pawn.linear_velocity.z = dir.z * speed
			
	
	
	
