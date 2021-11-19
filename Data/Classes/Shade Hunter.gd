extends Entity

func _ready():
	charname = "Shade Hunter"
	MaxHP = 88
	HP = 56
	MaxMP = 80
	MP = 80
	STR = 70
	DEF = 20
	SPD = 100
	HATE = 50
	row = "Back"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	skilllist = {
	"Poison_Arrow" : "An arrow dipped in Raklak poison secretions",
	"Burning_Arrow" : "An arrow dipped in molten inferno"
	}

func Poison_Arrow():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("Poison_Arrow2")

func Poison_Arrow2(target):
	var damage = 0.5*STR + 0.5*SPD
	target.take_damage(damage)
	
	target.AttemptStatusAilment("poison", 30, 2)
	
	MPCost(10)
	
	CloseTurn(str(charname) + " fires a poison drenched arrow at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")

func Burning_Arrow():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("Burning_Arrow2")

func Burning_Arrow2(target):
	var damage = 0.5*STR + 0.5*SPD
	target.take_damage(damage)
	
	target.AttemptStatusAilment("burn", 30, 2)
	
	MPCost(10)
	
	CloseTurn(str(charname) + " fires a flaming arrow at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")
