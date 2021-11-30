extends Entity

func _ready():
	charname = "Dancer"
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
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	skilllist = {
		"Raptor Samba" : "Increases Party-wide Strength",
		"Soothing Waltz" : "Applies a regen effect to the whole party.",
		"Invigorating Galliard" : "Increases Party-wide Speed",
		"Whirling Blades" : "Slashing damage to all front line enemies."
	}

func RaptorSamba():
	if MPCheck(30) == "fail": return
	var partylist = get_tree().get_nodes_in_group("partymembers")
	MPCost(30)
	for n in partylist:
		if n.HP != 0: n.StatMod("STR", 1.25, 2)
	CloseTurn(str(charname) + "'s Raptor Samba emboldens the party. Strength increased!")
  
func SoothingWaltz():
	if MPCheck(30) == "fail": return
	var partylist = get_tree().get_nodes_in_group("partymembers")
	MPCost(30)
	for n in partylist:
		if n.HP != 0: n.AttemptStatusAilment("regen", 30, 2)
	CloseTurn(str(charname) + "'s Soothing Waltz begins healing the party!")
   
func InvigoratingGalliard():
	if MPCheck(30) == "fail": return
	var partylist = get_tree().get_nodes_in_group("partymembers")
	MPCost(30)
	for n in partylist:
		if n.HP != 0: n.StatMod("SPD", 1.25, 2)
	CloseTurn(str(charname) + "'s Invigorating Galliad motivates the party. Speed increased!")

func WhirlingBlades():
	if MPCheck(30) == "fail": return
	var damage = (STR * statmods["STR"])*0.6
	var enemies = get_tree().get_nodes_in_group("enemies")
	MPCost(30)
	EventHandler.BattleLog(str(charname) + " performs a whirling dance of blades!")
	for target in enemies:
		if target.row == "Front":
			var adjusteddamage = target.take_damage(damage, "slash")
			EventHandler.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
	CloseTurn("")
