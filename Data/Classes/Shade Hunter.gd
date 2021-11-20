extends Entity

func _ready():
	charname = "Shade Hunter"
	MaxHP = 75
	HP = 75
	MaxMP = 60
	MP = 60
	STR = 50
	DEF = 20
	SPD = 100
	HATE = 50
	row = "Back"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	skilllist = {
	"Poison Arrow" : "An arrow dipped in Raklak poison secretions",
	"Burning Arrow" : "An arrow dipped in molten inferno"
	}

func PoisonArrow():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("PoisonArrow2")

func PoisonArrow2(target):
	var damage = 0.5*STR + 0.5*SPD
	target.take_damage(damage, "pierce")
	
	target.AttemptStatusAilment("poison", 70, 2)
	
	MPCost(10)
	
	CloseTurn(str(charname) + " fires a poison drenched arrow at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")

func BurningArrow():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("BurningArrow2")

func BurningArrow2(target):
	var damage = 0.5*STR + 0.5*SPD
	target.take_damage(damage, "pierce")
	
	target.AttemptStatusAilment("burn", 70, 2)
	
	MPCost(10)
	
	CloseTurn(str(charname) + " fires a flaming arrow at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")
