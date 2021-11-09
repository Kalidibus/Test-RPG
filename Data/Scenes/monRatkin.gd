extends Entity
class_name Ratkin

func _ready():
	charname = "Ratkin"
	MaxHP = 80
	HP = 80
	MaxMP = 5
	MP = 5
	STR = 5
	DEF = 5
	SPD = 20
	row = "Front"
	enemy = true
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
