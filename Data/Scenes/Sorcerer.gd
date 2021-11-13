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
	HATE = 30
	row = "Back"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)

func Turn(input):
	#placeholder to reset any temporary stat gains
	
	if row == "Front": HATE = 50
	
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
