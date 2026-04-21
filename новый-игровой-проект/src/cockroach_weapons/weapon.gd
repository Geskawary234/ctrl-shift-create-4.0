@tool
extends Node3D
class_name Weapon

@export var ap : AnimationPlayer
var deployment_anim : String = 'Animation'

@export var deployed : bool = false :
	set(v):
		deployed = v
				
		if deployed:
			$AnimationPlayer.play(deployment_anim)
		else:
			$AnimationPlayer.play(deployment_anim,-1,-1,true)
				
