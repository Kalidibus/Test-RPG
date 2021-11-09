extends Entity
class_name Kobold

func _ready():
	charname = "Kobold"
	MaxHP = 120
	HP = 120
	MaxMP = 5
	MP = 5
	STR = 5
	DEF = 5
	SPD = 8
	row = "Front"
	enemy = true
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
