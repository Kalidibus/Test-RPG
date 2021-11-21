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
		"Fel Bolt" : "A Fel aspected attack, dealing moderate damage.",
		"Deep Bolt" : "A Deep aspected attack, dealing moderate damage.",
		"Levin Bolt" : "A Deep aspected attack, dealing moderate damage.",
		"Fel Pact" : "Sacrfice HP for an equivilant amount of MP."
	#	"Fumeturgey" : "Great gusts of smoke engulf enemies, reducing their accuracy",
	#	"Pyrotica" : "Gouts of eldrich flame that raze enemy lines",
	#	"Inferno Bolt" : "A Fire aspected attack, dealing moderate damage"
	}

func FelBolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("FelBolt2")

func FelBolt2(target):
	var damage = INT * statmods["INT"]
	target.take_damage(damage, "fel") 
	
	MPCost(10)
	
	CloseTurn(str(charname) + " launches an eldritch bolt of ink black Fel magic at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")

func DeepBolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("DeepBolt2")

func DeepBolt2(target):
	var damage = INT * statmods["INT"]
	target.take_damage(damage, "deep") 
	
	MPCost(10)
	
	CloseTurn(str(charname) + " launches a bolt of icey Deep magic at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")

func LevinBolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("LevinBolt2")

func LevinBolt2(target):
	var damage = INT * statmods["INT"]
	target.take_damage(damage, "levin") 
	
	MPCost(10)
	
	CloseTurn(str(charname) + " launches a bolt of electric Levin magic at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")

func FelPact():
	take_damage(20, "true")
	MPCost(-20)
	
	CloseTurn(str(charname) + " exchanges blood for power. MP restored!")
