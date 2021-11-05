extends Entity

func _ready():
	charname = "Sorcerer"
	MaxHP = 40
	HP = 40
	MaxMP = 167
	MP = 134
	STR = 5
	DEF = 5
	SPD = 12
	position = "Front"
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, position)
