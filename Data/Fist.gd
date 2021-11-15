extends Entity

func _ready():
	charname = "Fist"
	MaxHP = 50
	HP = 50
	MaxMP = 80
	MP = 80
	STR = 70
	DEF = 20
	SPD = 30
	HATE = 50
	row = "Front"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	skilllist = {

	}
