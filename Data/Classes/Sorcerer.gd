extends Entity

func _ready():
	charname = "Fel Mage"
	MaxHP = 50
	HP = 50
	MaxMP = 175
	MP = 175
	STR = 5
	INT = 60
	DEF = 20
	SPD = 25
	HATE = 30
	row = "Back"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)

	skilllist = {
		"Fel Bolt" : "A Dark aspected attack, dealing moderate damage"
	#	"Fumeturgey" : "Great gusts of smoke engulf enemies, reducing their accuracy",
	#	"Pyrotica" : "Gouts of eldrich flame that raze enemy lines",
	#	"Inferno Bolt" : "A Fire aspected attack, dealing moderate damage"
	}

func FelBolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("FelBolt2")

func FelBolt2(target):
	var damage = INT
	target.take_damage(damage) #change to take magic damage?
	
	MPCost(10)
	
	CloseTurn(str(charname) + " launches an eldritch bolt of ink black magic at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")
