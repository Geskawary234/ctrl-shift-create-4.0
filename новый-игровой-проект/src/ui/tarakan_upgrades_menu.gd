extends Control

@onready var gun_upgrade_1: Control = $HBoxContainer/VBoxContainer/GunUpgrade1
@onready var gun_upgrade_2: Control = $HBoxContainer/VBoxContainer/GunUpgrade2

@onready var saw_upgrade_1: Control = $HBoxContainer/VBoxContainer2/SawUpgrade1
@onready var saw_upgrade_2: Control = $HBoxContainer/VBoxContainer2/SawUpgrade2

@onready var power_upgrade_1: Control = $HBoxContainer/VBoxContainer3/PowerUpgrade1
@onready var power_upgrade_2: Control = $HBoxContainer/VBoxContainer3/PowerUpgrade2

@export var pause_manager : Node
@export var pause_menu : Control


func _ready() -> void:
	power_upgrade_1.btn.pressed.connect(
		func():
			Global.tarakan_upgrades[Global.TarakanUpgrades.Health] = 1
			Global.TarakanUpgraded.emit(Global.TarakanUpgrades.Health)
			power_upgrade_2.locked = false
			power_upgrade_1.purchased = true
	)
	
	power_upgrade_2.btn.pressed.connect(
		func():
			Global.tarakan_upgrades[Global.TarakanUpgrades.Health] = 2
			Global.TarakanUpgraded.emit(Global.TarakanUpgrades.Health)
			power_upgrade_2.purchased = true
	)
	
	
	saw_upgrade_1.btn.pressed.connect(
		func():
			Global.tarakan_upgrades[Global.TarakanUpgrades.Saw] = 1
			Global.TarakanUpgraded.emit(Global.TarakanUpgrades.Saw)
			saw_upgrade_1.purchased = true
			saw_upgrade_2.locked = false
	)
	
	saw_upgrade_2.btn.pressed.connect(
		func():
			Global.tarakan_upgrades[Global.TarakanUpgrades.Saw] = 2
			Global.TarakanUpgraded.emit(Global.TarakanUpgrades.Saw)
			saw_upgrade_2.purchased = true
	)
	
	
	gun_upgrade_1.btn.pressed.connect(
		func():
			Global.tarakan_upgrades[Global.TarakanUpgrades.Guns] = 1
			Global.TarakanUpgraded.emit(Global.TarakanUpgrades.Guns)
			gun_upgrade_1.purchased = true
			gun_upgrade_2.locked = false
	)
	
	gun_upgrade_2.btn.pressed.connect(
		func():
			Global.tarakan_upgrades[Global.TarakanUpgrades.Guns] = 2
			Global.TarakanUpgraded.emit(Global.TarakanUpgrades.Guns)
			gun_upgrade_2.purchased = true
	)
	
var cooldown_timer : float = 0.1
var t : float = cooldown_timer
func _process(delta: float) -> void:
	
	if pause_menu.visible: return
	
	if t >0:
		t-=delta
	else:
		if Input.is_action_just_pressed('upgrade_ui'):
			hide()
			t = cooldown_timer
			pause_manager.pause_tree()
