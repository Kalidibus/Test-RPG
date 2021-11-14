extends Entity




func _ready():
	charname = "Fel Mage"
	MaxHP = 40
	HP = 40
	MaxMP = 167
	MP = 134
	STR = 5
	INT = 40
	DEF = 5
	SPD = 12
	HATE = 30
	row = "Back"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)

	skilllist = {
		"Fel_Bolt" : "A Dark aspected attack, dealing moderate damage",
		"Fumeturgey" : "Great gusts of smoke engulf enemies, reducing their accuracy",
		"Pyrotica" : "Gouts of eldrich flame that raze enemy lines",
		"Inferno Bolt" : "A Fire aspected attack, dealing moderate damage"
	}

func Fel_Bolt():
	CombatGUI.TargetList("Fel_Bolt2")

func Fel_Bolt2(target):
	var damage = 2*calcmagicdamage(self, target)
	target.take_damage(damage)
	
	EventHandler.BattleLog(str(charname) + " launches an eldritch bolt of ink black magic at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")
	yield(get_tree().create_timer(0.5), "timeout")
	CombatController.play_turn()
