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
		"Fel_Bolt" : "A Dark aspected attack, dealing moderate damage"
	#	"Fumeturgey" : "Great gusts of smoke engulf enemies, reducing their accuracy",
	#	"Pyrotica" : "Gouts of eldrich flame that raze enemy lines",
	#	"Inferno Bolt" : "A Fire aspected attack, dealing moderate damage"
	}

func Fel_Bolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("Fel_Bolt2")

func Fel_Bolt2(target):
	var damage = INT
	target.take_damage(damage) #change to take magic damage?
	
	MPCost(10)
	
	CloseTurn(str(charname) + " launches an eldritch bolt of ink black magic at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")
