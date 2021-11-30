extends Entity

func _ready():
	charname = "Dancer"
	MaxHP = 80
	HP = 80
	MaxMP = 100
	MP = 100
	STR = 60
	DEF = 50
	INT = 25
	FTH = 60
	RES = 50
	SPD = 50
	HATE = 60
	row = ""
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	skilllist = {
		"Raptor Samba" : "Increases Party-wide Strength",
<<<<<<< HEAD
	"Soothing Waltz" : "Applies a regen effect to the whole party.",
	"Invigorating Galliard" : "Increases Party-wide Speed"
=======
    "Soothing Waltz" : "Applies a regen effect to the whole party.",
    "Invigorating Galliard" : "Increases Party-wide Speed"
>>>>>>> parent of 3848970 (Bug Fixes)
	}

func RaptorSamba():
	if MPCheck(30) == "fail": return
	var partylist = get_tree().get_nodes_in_group("partymembers")
	MPCost(30)
	for n in partylist:
<<<<<<< HEAD
	if n.HP != 0: StatMod("STR", 1.25, 2)
=======
    if n.HP != 0: StatMod("STR", 1.25, 2)
>>>>>>> parent of 3848970 (Bug Fixes)
  CloseTurn(str(charname) + "'s Raptor Samba emboldens the party. Strength increased!")
  
func SoothingWaltz():
	if MPCheck(30) == "fail": return
	var partylist = get_tree().get_nodes_in_group("partymembers")
	MPCost(30)
	for n in partylist:
<<<<<<< HEAD
	if n.HP != 0: AttemptStatusAilment("regen", 30, 2)
=======
    if n.HP != 0: AttemptStatusAilment("regen", 30, 2)
>>>>>>> parent of 3848970 (Bug Fixes)
  CloseTurn(str(charname) + "'s Soothing Waltz begins healing the party!")
   
func InvigoratingGalliard():
	if MPCheck(30) == "fail": return
	var partylist = get_tree().get_nodes_in_group("partymembers")
	MPCost(30)
	for n in partylist:
<<<<<<< HEAD
	if n.HP != 0: StatMod("SPD", 1.25, 2)
=======
    if n.HP != 0: StatMod("SPD", 1.25, 2)
>>>>>>> parent of 3848970 (Bug Fixes)
  CloseTurn(str(charname) + "'s Invigorating Galliad motivates the party. Speed increased!")
