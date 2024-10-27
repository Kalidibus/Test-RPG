extends Entity

var starting_stats = {
		"HP" = 80,
		"MP" = 120,
		"STR" = 70,
		"DEF" = 50,
		"INT" = 25,
		"FTH" = 60,
		"RES" = 50,
		"SPD" = 60
		}

func _ready():
	charname = "Illusionist"
	MaxHP = 80
	HP = 80
	MaxMP = 120
	MP = 120
	STR = 70
	DEF = 50
	INT = 25
	FTH = 60
	RES = 50
	SPD = 50
	HATE = 60
	row = "Front"
	enemy = false
	weapontype = "slash"
	
	skilllist = {
		"Black Mist" : "Increases Party-wide Evasion"
	}

func BlackMist():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "RaptorSamba2")
func BlackMist2():
	var partylist = get_tree().get_nodes_in_group("partymembers")
	MPCost(30)
	for n in partylist:
		if n.HP != 0: n.StatMod("SPD", 1.25, 2)
	CloseTurn(str(charname) + "'s Black Mist billows across the battlefield. Evasion increased!")
  
