extends Entity

var PASSIVE_accumulate_ire = true
var ire = 0

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
		"Taunt" : "Marks self, increasing odds of enemies targetting Fortress. Also increases base aggro.",
		"Vanguard" : "A savage blow with both shields. Deals high impact damage scaling with DEF.",
		"Bastion" : "Restores HP to target party member. Amount healed scales with DEF.",
		"Embolden" : "Boosts the DEF stat for 3 turns.",
		"Skull Splitter" : "COST '1 Ire' - An overhead strike. Has a chance to stun an enemy."
	}

func Turn():
	.Turn() #calls the parent Turn function. 
	PASSIVE_accumulate_ire = false #reset ire accumulation

func Defend():
	.Defend()
	PASSIVE_accumulate_ire = true

func take_damage(damage, type):
	.take_damage(damage, type)
	if PASSIVE_accumulate_ire == true: ire += 1

func Taunt():
	if MPCheck(10) == "fail": return
	if not status.has("marked"): status.append("marked")
	markedamount = 80
	markedcount = 2
	HATE += 50
	MPCost(10)
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

func SkullSplitter():
	if ire == 0:
		EventHandler.BattleLog("Need Ire to perform this action!")
		return
	else: CombatGUI.TargetList("SkullSplitter2")
func SkullSplitter2(target):
	var damage = DEF * statmods["DEF"] + STR * statmods["STR"]
	target.take_damage(damage, "impact")
	ire -= 1
	CloseTurn(str(charname) + " uses Ire to perform a crushing overhead blow! to " + str(target.charname) + "!")
	target.AttemptStatusAilment("stun", 0, 0)
