extends Entity

func _ready():
	charname = "Kobold"
	MaxHP = 20
	HP = 20
	MaxMP = 5
	MP = 5
	STR = 5
	DEF = 5
	position = "Front"
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, position)
