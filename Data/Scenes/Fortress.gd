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
	HATE = 50
	row = "Front"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	skilllist = {
		"Vanguard" : "Does something really cool",
		"Bastion" : "Does something even cooler",
		"DICKSUCK" : "SUKK REAL HARD YUM YUM",
		"new ability" : "yes"
	}

func Turn(input):
	#placeholder to reset any temporary stat gains
	
	if row == "Front": HATE = 70
	
	if input == "Attack":
		Attack()
	else:
		pass

func Attack():
	#target = Selector.GetTarget()
	var target = Selector.GetTarget()
	var damage = calcdamage(self, target)
	target.take_damage(damage)
	
	EventHandler.BattleLog(str(charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")
