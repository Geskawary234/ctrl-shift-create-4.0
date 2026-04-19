extends Controller


var alert_level : float    # alert level from 0 to 100, when it reaches
						   # 100, cockroach gets into attacking state
@onready var alert_others_area: Area3D = $"../AlertOthersArea"
@onready var fmod_emitter: FmodEventEmitter3D = $"../FmodEventEmitter3D"
@onready var model_ap: AnimationPlayer = $"../cocroch".get_node('AnimationPlayer')


var target : Pawn	
		
# thinking
var delta_accum : float = 0
var think_time : float = 0.2
var think_timer : float

# combat
var attack_speed : float = 0.4
var attack_timer : float = 0

#other
var speed : float = 0.3
var state : States 
enum States {
	Idle,
	Walking,
	Suspecting,
	Attacking,
	Talking,
	Dancing
}

@onready var prog_bar_view: Sprite3D = $"../ProgBarView"
@onready var lamp_progress: TextureProgressBar = $"../ProgBarView/SubViewport/Control/LampProgress"
@onready var alerted_sprite: Sprite3D = $"../AlertedSprite"
@onready var speaking_particles: CPUParticles3D = $"../SpeakingParticles"


func _ready() -> void:
	super()
	speaking_particles.emitting = false
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
				blink_alert_sprite()
				
				for t in alert_others_area.get_overlapping_bodies():
					t.emit_signal('increase_level',100,player_pawn)
			
			if player_pawn:
				target = player_pawn
			
			if target:
				GameServer.interpolated_look_at(pawn,target.global_position)
			lamp_progress.value = alert_level
		)
	
	pawn.set_state.connect(func(st : States): state = st)
	pawn.set_speaking_time.connect(func(v : float): speaking_time = v)
	pawn.set_partner.connect(func(p : TarakanPawn): speaking_partner = p)
		
	pawn.body_entered.connect(func(b):
		if alert_level < 100:
		
		
			if b is TarakanPawn:
				if !b.speaking:
					if randi_range(0,25) == 0:
						state = States.Talking
						speaking_time = randi_range(1,3)
						pawn.speaking = true
						speaking_partner = b
						
						
						b.emit_signal('set_speaking_time',speaking_time)
						b.emit_signal('set_partner',pawn)
						b.speaking = true
						b.emit_signal('set_state',States.Talking)
						
						
		
		)



var dir : Vector3
var walk_time : float = 0 # for how long cockroaches goes in "dir" direction
var speaking_time : float = 0
var speaking_partner : TarakanPawn
func pawn_physics_process(delta : float):
	super(delta)
	if think_timer<=0:
		think(delta_accum)
		think_timer = think_time
	else:
		think_timer -= delta
		delta_accum += delta

# cockroach thinks every few moments
func think(delta_accum : float):
	speaking_particles.emitting = false
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
			
		
			pawn.look_at(target.global_position)
			
			var d := target.global_position - global_position
			
			dir = d.normalized()
			
			pawn.linear_velocity.x = dir.x * speed
			pawn.linear_velocity.z = dir.z * speed
			
			if d.length()<=0.05:
				if attack_timer<=0:
					target.health -= 1
					attack_timer = attack_speed
			
			attack_timer -= delta_accum
			
			
			
			
		
		States.Talking:
			pawn.linear_velocity.x = 0
			pawn.linear_velocity.z = 0
			

			pawn.look_at(speaking_partner.global_position)
				
			speaking_particles.emitting = true
			
			if speaking_time>0:
				speaking_time -= delta_accum
			else:
				speaking_particles.emitting = false
				speaking_partner = null
				pawn.speaking = false
				state = States.Idle
	
	if pawn.linear_velocity.length()>0.1:
		model_ap.play('2_Walk_Fix_001')
		fmod_emitter.play()
	else:
		model_ap.stop()
		fmod_emitter.stop()
			
func blink_alert_sprite():
	alerted_sprite.show()
	await get_tree().create_timer(0.5,false).timeout
	alerted_sprite.hide()
	
	
