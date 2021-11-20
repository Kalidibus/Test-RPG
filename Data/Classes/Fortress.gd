extends Entity

func _ready():
	charname = "Fortress"
	MaxHP = 125
	HP = 125
	MaxMP = 80
	MP = 80
	STR = 50
	DEF = 75
	INT = 25
	FTH = 50
	RES = 50
	SPD = 25
	HATE = 100
	row = "Front"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	skilllist = {
		"Taunt" : "Increase chances of enemies targetting you",
		"Vanguard" : "Hits the enemy with BOTH shields at once. Scales with DEF",
		"Bastion" : "Provides a DEF based heal to target party member",
		"Embolden" : "boost DEF for 3 turns"
	}

func Taunt():
	if MPCheck(10) == "fail": return
	
	if not status.has("marked"): status.append("marked")
	markedamount = 80
	markedcount = 2
	
	HATE += 50
	
	MPCost(10)
	
	print(status)
	print(HATE)
	
	CloseTurn(str(charname) + " draws enemy attention!")

func Vanguard():
	if MPCheck(40) == "fail": return
	else: CombatGUI.TargetList("Vanguard2")

func Vanguard2(target):
	var damage = DEF * statmods["DEF"]
	target.take_damage(damage, "impact")
	
	MPCost(40)
	
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")

func Bastion():
	if MPCheck(40) == "fail": return
	else: CombatGUI.AllyTargetList("Bastion2")

func Bastion2(target):
	var heal = 2*DEF
	target.get_healed(heal)
	
	MPCost(40)

	CloseTurn(str(charname) + " provides shelter behind her shields to " + str(target.charname) + ", healing her for " + str(heal) + " HP!")

func Embolden():
	if MPCheck(20) == "fail": return
	
	MPCost(20)
	
	StatMod("DEF", 1.25, 2)
	
	CloseTurn(str(charname) + " takes on a defensive stances! DEF Increased.")

