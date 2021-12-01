extends Entity

func _ready():
	charname = "Cleric"
	MaxHP = 75
	HP = 75
	MaxMP = 125
	MP = 125
	STR = 25
	DEF = 50
	INT = 75
	FTH = 125
	RES = 100
	SPD = 75
	HATE = 50
	row = "Back"
	enemy = false
	weapontype = "impact"
	
	skilllist = {
		"Bounty" : "Heals an allied unit",
		"Full Blessing" : "Heals the party",
		"Divine Bolt" : "A modest bolt of light, damages a single enemy",
		"Resurrect" : "Raises one ally from the dead"
	}

func Bounty():
	if MPCheck(10) == "fail": return
	else: CombatGUI.AllyTargetList("Bounty2")

func Bounty2(target):
	if target.HP == 0:
		EventHandler.BattleLog("This target must be raised from the dead first")
		return
	
	var heal = FTH
	target.get_healed(heal)
	
	MPCost(10)

	CloseTurn(str(charname) + " blesses " + str(target.charname) + " with the bounty of the forest, healing her for " + str(heal) + " HP!")

func FullBlessing():
	if MPCheck(50) == "fail": return
	var partylist = get_tree().get_nodes_in_group("partymembers")
	
	MPCost(50)
	
	for n in partylist:
		if n.HP != 0:
			n.get_healed(FTH)
	CloseTurn(str(charname) + " Restores the parties health for " + str(FTH) + "!")

func DivineBolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("DivineBolt2")

func DivineBolt2(target):
	var damage = INT * statmods["INT"]
	target.take_damage(damage, "virtuos")
	
	MPCost(10)
	
	CloseTurn(str(charname) + " launches an divine bolt of cleansing magic at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")

func Resurrect():
	if MPCheck(50) == "fail": return
	else: CombatGUI.AllyTargetList("Resurrect2")

func Resurrect2(target):
	if target.HP != 0:
		EventHandler.BattleLog("This target is not dead!")
		return
	
	var heal = FTH
	target.get_healed(heal)
	target.dead = false
	
	MPCost(50)

	CloseTurn(str(charname) + " blesses " + str(target.charname) + " with the bounty of the forest, healing her for " + str(heal) + " HP!")
