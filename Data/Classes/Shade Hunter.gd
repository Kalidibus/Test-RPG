extends Entity

func _ready():
	charname = "Shade Hunter"
	MaxHP = 88
	HP = 56
	MaxMP = 80
	MP = 80
	STR = 70
	DEF = 20
	SPD = 5
	HATE = 50
	row = "Back"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	skilllist = {

	}
