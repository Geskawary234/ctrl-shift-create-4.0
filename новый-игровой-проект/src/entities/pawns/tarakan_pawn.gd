extends Pawn
class_name TarakanPawn

signal increase_level(v : float, player_pawn : Pawn)
signal set_state(state : int)
signal set_speaking_time(value : float)
signal set_partner(p : TarakanPawn)


var speaking : bool = false
