extends Pawn
class_name PlayerHumanPawn

@export var speed : float = 3
@export var spring_len : float = 5

@onready var col_shape: Shape3D = $CollisionShape3D.shape
