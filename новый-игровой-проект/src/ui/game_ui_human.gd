extends Control

@onready var player_controller: PlayerController = $"../../../.."

@onready var slot_forward: Slot = $VBoxContainer/SlotForward
@onready var slot_active: Slot = $VBoxContainer/SlotActive
@onready var slot_back: Slot = $VBoxContainer/SlotBack
@onready var item_tooltip: Label = $VBoxContainer/SlotActive/VBoxContainer/ItemTooltip
@onready var hint: Label = $VBoxContainer/SlotActive/VBoxContainer/hint


@onready var pointer: TextureRect = $pointer
@onready var pointer_hint: Label = $pointer/Hint

const HOLD = preload("uid://7f3m0w3xd6dr")
const STORE_IN_INVETORY = preload("uid://dfygsb65ofhau")



var inventory: Dictionary[InventoryItem, Array] = {}
var cursor_pos: int = 0


func _ready() -> void:
	update_inventory_ui()


func _process(delta: float) -> void:
	# Debug info
	#$Label.text = str(inventory) + "\ncursor pos " + str(cursor_pos)

	# Handle scroll
	if player_controller.mouse_wheel_input != 0:
		cursor_pos -= player_controller.mouse_wheel_input
		cursor_pos = clamp(cursor_pos, 0, max(inventory.size() - 1, 0))
		update_inventory_ui()
		equip_item()
	
	if Input.is_action_just_pressed('throw_item_from_inventory'):
		throw_current_item()


func found_item(item: PickableItem) -> void:
	
	var item_info := item.item_info

	if inventory.has(item_info):
		inventory[item_info].append(item)
		
		item.set_process(false)
		item.set_physics_process(false)
		item.hide()
		
	else:
		inventory[item_info] = [item]
	
	player_controller.pawn.add_collision_exception_with(item)
	item.reparent(hand)
	item.position = Vector3.ZERO
	item.rotation = Vector3.ZERO
	
	#item.queue_free()
	update_inventory_ui()
	equip_item()


func update_inventory_ui() -> void:
	var keys: Array = inventory.keys()

	# Handle empty inventory
	if keys.is_empty():
		slot_active.icon = null
		slot_active.count = 0
		
		item_tooltip.text = ''
		hint.hide()

		slot_forward.hide()
		slot_back.hide()
		return

	# Clamp cursor safely
	cursor_pos = clamp(cursor_pos, 0, keys.size() - 1)

	# Active slot
	var curr_item: InventoryItem = keys[cursor_pos]
	slot_active.icon = curr_item.icon
	slot_active.count = len(inventory[curr_item])
	item_tooltip.text = str(curr_item.item_name)
	hint.show()

	# Forward (previous item)
	if cursor_pos > 0:
		var forward_item: InventoryItem = keys[cursor_pos - 1]
		slot_forward.icon = forward_item.icon
		slot_forward.count = len(inventory[forward_item])
		slot_forward.show()
	else:
		slot_forward.hide()

	# Back (next item)
	if cursor_pos < keys.size() - 1:
		var back_item: InventoryItem = keys[cursor_pos + 1]
		slot_back.icon = back_item.icon
		slot_back.count = len(inventory[back_item])
		slot_back.show()
	else:
		slot_back.hide()

func throw_current_item():
	if inventory.is_empty():
		return
	
	var keys: Array = inventory.keys()
	cursor_pos = clamp(cursor_pos, 0, keys.size() - 1)
	
	var item_info: InventoryItem = keys[cursor_pos]
	
	# Remove one item from inventory
	
	var throw_away_item = inventory[item_info][0]
	inventory[item_info].erase(throw_away_item)
	
	if len(inventory[item_info]) <= 0:
		inventory.erase(item_info)
		cursor_pos = clamp(cursor_pos, 0, max(inventory.size() - 1, 0))
	
	# remove item from hand
	#equipped_item.queue_free()
	throw_away_item.reparent(get_tree().current_scene)
	equipped = false

	# Spawn item in world
	var spawn_pos : Vector3
	if player_controller.rc.is_colliding():
		spawn_pos = player_controller.rc.get_collision_point() + player_controller.rc.get_collision_normal() * 0.2
	else:
		spawn_pos = player_controller.camera.global_position-player_controller.camera.global_basis.z
	
	throw_away_item.global_position = spawn_pos
	
	player_controller.pawn.remove_collision_exception_with(throw_away_item)
	throw_away_item.freeze = false
	
	
	if throw_away_item is ItemWeapon:
		throw_away_item.uneqquiped.emit()
	#GameServer.spawn(load(item.scene),spawn_pos,get_tree().current_scene)
	
	update_inventory_ui()
	equip_item()

@onready var hand: Node3D = $"../Hand"
var equipped : bool = false
var equipped_item : PickableItem
var equipped_item_index : int
func equip_item():
	if equipped:
		if equipped_item_index != cursor_pos:
			equipped_item.hide()
			equipped_item.set_process(false)
			equipped_item.set_physics_process(false)
			equipped = false
		else:
			return
		
	
	
	if inventory.is_empty():
		equipped = false
		return
	
	var keys: Array = inventory.keys()
	cursor_pos = clamp(cursor_pos, 0, keys.size() - 1)
	
	var item_info: InventoryItem = keys[cursor_pos]
	
	
	#var it : PickableItem = GameServer.spawn(load(item.scene),hand.global_position,hand)
	var it : PickableItem = inventory[item_info][0]
	it.set_process(true)
	it.set_physics_process(true)
	it.show()
	
	it.position = Vector3.ZERO
	it.rotation = Vector3.ZERO

	equipped_item = it
	equipped_item_index = cursor_pos
	equipped_item.freeze = true
	
	if equipped_item is ItemWeapon:
		equipped_item.eqquiped.emit()
	
	

	equipped = true
