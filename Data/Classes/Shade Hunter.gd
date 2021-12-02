extends Entity

func _ready():
	charname = "Shade Hunter"
	MaxHP = 60
	HP = 60
	MaxMP = 60
	MP = 60
	STR = 50
	DEF = 20
	SPD = 100
	HATE = 50
	row = "Back"
	enemy = false
	weapontype = "pierce"
	
	skilllist = {
	"Poison Arrow" : "An arrow dipped in Raklak poison secretions. Can inflict Poison.",
	"Burning Arrow" : "An arrow dipped in molten inferno. Can inflict Burn.",
	"Bladed Volley" : "Slashing damage to all back line enemies.",
	"Plate Crusher" : "A single target impact based shot with a chance to reduce enemies DEF.",
	"Isolate Prey" : "Target weak links in the enemies lines. Moderate piercing damage that scales with SPD. Deal bonus damage for each status ailment on target."
	}

func PoisonArrow():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("PoisonArrow2")
func PoisonArrow2(target):
	var damage = (SPD * statmods["SPD"])*0.5
	var adjusteddamage = target.take_damage(damage, "pierce")
	MPCost(10)
	CloseTurn(str(charname) + " fires a poison drenched arrow at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")
	target.AttemptStatusAilment("poison", 40, 3)

func BurningArrow():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("BurningArrow2")
func BurningArrow2(target):
	var damage = (SPD * statmods["SPD"])*0.5
	var adjusteddamage = target.take_damage(damage, "pierce")
	MPCost(10)
	CloseTurn(str(charname) + " fires a flaming arrow at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")
	target.AttemptStatusAilment("burn", 40, 3)
	
func BladedVolley():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "BladedVolley2")
func BladedVolley2():
	var damage = (SPD * statmods["SPD"])*0.6
	var enemies = get_tree().get_nodes_in_group("enemies")
	MPCost(30)
	EventHandler.BattleLog(str(charname) + " fires a Bladed Volley!")
	for target in enemies:
		if target.row == "Back" and target.HP != 0:
			var adjusteddamage = target.take_damage(damage, "slash")
			EventHandler.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			yield(get_tree().create_timer(0.5), "timeout")
	CloseTurn("")

func PlateCrusher():
	if MPCheck(20) == "fail": return
	CombatGUI.TargetList("PlateCrusher2")
func PlateCrusher2(target):
	var damage = (SPD * statmods["SPD"])
	var adjusteddamage = target.take_damage(damage, "impact")
	MPCost(20)
	CloseTurn(str(charname) + " fires a flaming arrow at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")
	var rng = RNG()
	if rng >= 50: target.StatMod("DEF", 0.6, 2)

func IsolatePrey():
	if MPCheck(20) == "fail": return
	CombatGUI.TargetList("IsolatePrey2")
func IsolatePrey2(target):
	var damage = max((SPD * statmods["SPD"])*0.5, (SPD * statmods["SPD"]) * target.status.size())
	var adjusteddamage = target.take_damage(damage, "pierce")
	MPCost(20)
	CloseTurn(str(charname) + " strikes at the vitals of the weakened " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")
