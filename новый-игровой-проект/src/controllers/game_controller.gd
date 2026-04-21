extends PlayerController

@export var game_manager : GameManager
@export var rc : RayCast3D

@onready var game_ui_human: Control = $SpringArm3D/CameraPivot/Camera3D/GameUIHuman
@onready var game_ui_tarakan: Control = $SpringArm3D/CameraPivot/Camera3D/GameUITarakan
@onready var black_screen: Control = $SpringArm3D/CameraPivot/Camera3D/BlackScreen
@onready var fmod_listener_3d: FmodListener3D = $FmodListener3D
@onready var hand: Node3D = $SpringArm3D/CameraPivot/Camera3D/Hand


func _process(delta: float) -> void:
	super(delta)
	
func pawn_physics_process(delta: float) -> void:
	super(delta)
	if !camera.current: return
	
	fmod_listener_3d.global_position = pawn.global_position
	fmod_listener_3d.global_rotation = pawn.global_rotation
	
	if pawn is PlayerHumanPawn:
		human_pawn_process(delta)
	elif pawn is PlayerTarakanPawn:
		tarakan_pawn_process(delta)

func pawn_changed(old : Pawn):
	super(old)
	
	if pawn is PlayerHumanPawn:
		camera.position = Vector3(0,0.5,0)
		spring_arm_len = pawn.spring_len
		camera_mode = 0
		speed = pawn.speed
		hand.show()
		hand.set_process(true)
		hand.set_physics_process(true)
		game_ui_human.show()
		game_ui_tarakan.hide()
	elif pawn is PlayerTarakanPawn:
		camera.position = Vector3.ZERO
		spring_arm_len = pawn.spring_len
		camera_mode = 1
		speed = pawn.speed
		hand.hide()
		hand.set_process(false)
		hand.set_physics_process(false)
		game_ui_human.hide()
		game_ui_tarakan.show()
		
		pawn.AddRune.connect(func(): $SpringArm3D/CameraPivot/Camera3D/GameUITarakan.runes += 1)
	
	
	initial_cam_position = camera.position
	

func tarakan_pawn_process(delta : float):
	pass


var dragg_item : DraggableItem
var item_held_pos : Vector3
var can_use_item : bool = true
func human_pawn_process(delta : float):
	camera_shake(delta)
	can_use_item = true
	
	if Input.is_action_pressed('crouch'):
		pawn.col_shape.height = lerp(pawn.col_shape.height,1.0,delta * 2)
		camera.position = camera.position.lerp(Vector3(0,-0.3,0),delta * 2)
		
		
	else:
		pawn.col_shape.height = lerp(pawn.col_shape.height,2.0,delta * 2)
		camera.position = camera.position.lerp(Vector3(0,0.5,0),delta * 2)
	
	var col : Variant
	if rc.is_colliding():
		col = rc.get_collider()
		if col is Item:
			can_use_item = false
	
	if Input.is_action_just_pressed('lmb') and game_ui_human.equipped and can_use_item:
		if game_ui_human.equipped_item is ItemWeapon:
			game_ui_human.equipped_item.main()

	if col:
		if col is Bed:
			game_ui_human.pointer.texture = game_ui_human.HOLD
			
			if col.bed_cooldown<=0:
				game_ui_human.pointer_hint.text = 'Кровать, нажмите [E] чтобы проспать до вечера'
				
				if Input.is_action_just_pressed('interact'):
					black_screen.activate()
					Global.GM.go_to_sleep()
				
			else:
				game_ui_human.pointer_hint.text = 'Кровать, чтобы проспать до вечера осталось подождать ' + str(col.bed_cooldown) + ' секунд.'
		
		elif col is DraggableItem:
			game_ui_human.pointer.texture = game_ui_human.HOLD
			game_ui_human.pointer_hint.text = 'Удерживайте [ЛКМ] для перетягивания'
		elif col is PickableItem:
			game_ui_human.pointer.texture = game_ui_human.STORE_IN_INVETORY
			game_ui_human.pointer_hint.text = 'Нажмите [E] чтобы поднять'
		else:
			game_ui_human.pointer.texture = null
			game_ui_human.pointer_hint.text = ''
		
		if Input.is_action_pressed('lmb'):
			if !dragg_item:
				if col is DraggableItem:
					dragg_item = rc.get_collider()
					dragg_item.gravity_scale = 0
					item_held_pos = dragg_item.to_local(rc.get_collision_point())
	else:
		game_ui_human.pointer_hint.text = ''
		if !dragg_item:
			game_ui_human.pointer.texture = null
	
	if Input.is_action_just_released('lmb'):
		if dragg_item:
			dragg_item.gravity_scale = 1
		dragg_item = null		
	
	
	if dragg_item:
		process_dragg_item(delta)
		
	if Input.is_action_just_pressed('interact'):
		if col is PickableItem:
			game_ui_human.found_item(col)




var damping := 1000
var power := 10
func process_dragg_item(delta : float):
	var target_position : = -camera.global_basis.z*2 + camera.global_position
	var to_target = target_position - dragg_item.to_global(item_held_pos)
		
	if dragg_item is DraggableItem:
		var light_item: DraggableItem = dragg_item
		
		
		var distance = to_target.length()
		
		var kp := 40.0  # position strength
		var kd := 12.0  # damping (VERY important)
		
		var slow_radius := 2.0
		var stop_radius := 0.1
		
		var desired_velocity := Vector3.ZERO
		
		if distance > stop_radius:
			var dir = to_target.normalized()
			var speed := power
			
			# Slow down near target (arrival)
			if distance < slow_radius:
				speed *= distance / slow_radius
			
			desired_velocity = dir * speed
		
		# PD control: match velocity + damp movement
		var velocity_error = desired_velocity - light_item.linear_velocity
		var force = velocity_error * kp - light_item.linear_velocity * kd
		
		light_item.apply_force(force)
		
		# Angular damping
		
		light_item.angular_velocity = light_item.angular_velocity.move_toward(
			Vector3.ZERO,
			delta * damping
		)
	
	'''
	elif dragg_item is HeavyItem:
		var heavy_item : HeavyItem = dragg_item
		var force = ndir * power

		# Apply force at grab point (global!)
		heavy_item.apply_force(force, item_held_pos)

		# Limit angular velocity properly
		var max_ang_speed = 5.0
		if heavy_item.angular_velocity.length() > max_ang_speed:
			heavy_item.angular_velocity = heavy_item.angular_velocity.normalized() * max_ang_speed
					
'''
