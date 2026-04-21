extends Control

@onready var player_controller: Node3D = $"../../../.."
@export var pause_manager : Node
@onready var ok_btn: Button = $ColorRect/OkBtn


var item_name : String :
	set(v):
		item_name = v
		$ColorRect/VBoxContainer/ItemName.text = v
		
var item_info : String :
	set(v):
		item_info = v
		$ColorRect/VBoxContainer/Info.text = v

func _ready() -> void:
	hide()
	
	ok_btn.pressed.connect(
		func():
		hide()
		pause_manager.pause_tree()
		)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('info') and !player_controller.black_screen.activated:
		if !visible:
			pause_manager.pause_tree()
			
			
			var it : PickableItem = player_controller.game_ui_human.equipped_item
			if it:
				
				var res : InventoryItem = it.item_info
				
				item_name = res.item_name
				item_info = res.description
			
			show()
			
			
			
