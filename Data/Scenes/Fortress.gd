extends Entity

func _ready():
	charname = "Fortress"
	MaxHP = 88
	HP = 56
	MaxMP = 67
	MP = 34
	STR = 20
	DEF = 10
	SPD = 5
	position = "Front"
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, position)
