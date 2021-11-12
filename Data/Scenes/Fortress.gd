extends Entity

func _ready():
	charname = "Fortress"
	MaxHP = 88
	HP = 56
	MaxMP = 67
	MP = 34
	STR = 20
	DEF = 20
	SPD = 5
	row = "Front"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)

func Turn(input):
	if input == "Attack":
		Attack()
	else:
		pass

func Attack():
	#target = Selector.GetTarget()
	pass
