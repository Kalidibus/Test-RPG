extends Entity

func _ready():
	charname = "Forest Healer"
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
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	skilllist = {
		"Bounty" : "Heals an allied unit",
		"Full_Blessing" : "Heals the party",
		"Divine_Bolt" : "A modest bolt of light, damages enemies and restores MP"
	}

func Bounty():
	if MPCheck(10) == "fail": return
	else: CombatGUI.AllyTargetList("Bounty2")

func Bounty2(target):
	var heal = FTH
	target.get_healed(heal)
	
	MPCost(10)

	CloseTurn(str(charname) + " blesses " + str(target.charname) + " with the bounty of the forest, healing her for " + str(heal) + " HP!")

func Full_Blessing():
	if MPCheck(50) == "fail": return
	var partylist = get_tree().get_nodes_in_group("partymembers")
	
	MPCost(50)
	
	for n in partylist:
		if n.HP != 0:
			n.get_healed(FTH)
	CloseTurn(str(charname) + " Restores the parties health for " + str(FTH) + "!")

func Divine_Bolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("Divine_Bolt2")

func Divine_Bolt2(target):
	var damage = INT
	target.take_damage(damage) #change to take magic damage?
	
	MPCost(-20)
	
	CloseTurn(str(charname) + " launches an divine bolt of cleansing magic at " + str(target.charname) + ", hitting it for " + str(damage) + " damage! MP restored!")
