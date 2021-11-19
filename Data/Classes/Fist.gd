extends Entity

func _ready():
	charname = "Fist"
	MaxHP = 100
	HP = 100
	MaxMP = 80
	MP = 80
	STR = 70
	DEF = 20
	SPD = 30
	HATE = 50
	row = "Front"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	skilllist = {
		"Violet Fist": "Strikes an opponent with a flurry of blows. Scales with SPD and STR",
		"Bastard Spirit" : "Raises STR for 3 turns",
		"Lunatic Spirit" : "Greatly raises STR and SPD for 3 turns, but reduces DEF"
	}

func VioletFist():
	if MPCheck(40) == "fail": return
	else: CombatGUI.TargetList("VioletFist2")

func VioletFist2(target):
	var damage = (STR/50+SPD/25)*calcdamage(self, target)
	target.take_damage(damage)
	target.take_damage(damage)
	target.take_damage(damage)
	
	MPCost(40)
	
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")

func BastardSpirit():
	if MPCheck(20) == "fail": return
	
	MPCost(20)
	
	StatMod("STR", 1.25, 2)
	
	CloseTurn(str(charname) + " draws upon her Bastard Spirit. STR Increased.")

func LunaticSpirit():
	if MPCheck(20) == "fail": return
	
	MPCost(20)
	
	StatMod("STR", 1.5, 2)
	StatMod("SPD", 1.5, 2)
	StatMod("DEF", 0.6, 2)
	
	
	CloseTurn(str(charname) + " draws upon her Lunatic Spirit. STR and SPD Increased! DEF Decreased.")

