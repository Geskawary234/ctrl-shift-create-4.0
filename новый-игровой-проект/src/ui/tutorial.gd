@tool
extends Control
class_name TutorialNode

@onready var tutorial_name: Label = $Control/Panel/TutorialName
@onready var tutorial_info: Label = $Control/TutorialInfo
@onready var step_progress: ProgressBar = $Control/StepProgress
@onready var skip_tip: Label = $Control/StepProgress/SkipTip

@export var current_step : int = 0 :
	set(v):
		if Engine.is_editor_hint() or (tutorial_info and steps):
			
			if v>len(steps)-1:
				finished.emit()
				hide()
			
			current_step = clamp(v,0,len(steps)-1)
			
			if len(steps)<1:
				tutorial_info.text = '<Не существует туториала>'
				
			else:
				tutorial_info.text = steps[current_step].step_text
			
		
@export var steps : Array[TutorialStep]

signal appear
signal start_filling
signal finished
signal setup_next

func _ready() -> void:
	if Engine.is_editor_hint(): return
	current_step = 0
		
	hide()
	skip_tip.hide()
		
		
	start_filling.connect(
		func(): 
			if !Global.GM.enable_tutorial: return
			
			
			fill_up = true
			)
		
	appear.connect(
		func():
			if !Global.GM.enable_tutorial: return
			
			show()
			
	)


var fill_up : bool = false
var fill_up_speed : float = 20
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if fill_up:
		step_progress.value += delta * steps[current_step].speed
			
		if step_progress.value >= 100:
			skip_tip.show()
				
			if Input.is_action_just_pressed('continue_tutorial'):
				current_step += 1
				step_progress.value = 0
				skip_tip.hide()
