extends Entity

var PASSIVE_accumulate_ire = true
var ire = 0

var jobid = "0"

var starting_stats = {
		"HP" = 125,
		"HPmax" = 125,
		"MP" = 50,
		"MPmax" = 50,
		"STR" = 50,
		"DEF" = 75,
		"INT" = 25,
		"FTH" = 50,
		"RES" = 50,
		"EVD" = 20,
		"SPD" = 25
		}

var stat_scaling = {
		"HPmax" = "A",
		"MPmax" = "C",
		"STR" = "B",
		"DEF" = "S",
		"INT" = "C",
		"FTH" = "C",
		"RES" = "B",
		"EVD" = "D",
		"SPD" = "D"
	}

var job_description = "An iron wall to keep Lamentations at bay. \n\nThe Fortress vocation excels at defending the party from physical attacks. Taking hits from enemies repeatedly will also accumulate a resource called [b]Ire[/b] which can be used to trigger powerful counter-attacks. \n\nWhile the Fortresses' shields can protect against magic attacks to some degree, they are not as well suited for foes that deal elemental damage."

func _ready():
	HATE = 100
	weapontype = "impact"

func GetSkills():
	skill_list = {
		"skillFORTRESS01" = {"skillname" = "Taunt",
			"skilldesc" = "Marks self, increasing odds of enemies targetting Fortress. Also increases base aggro."},
		"skillFORTRESS02" = {"skillname" = "Vanguard",
			"skilldesc" = "A savage blow with both shields. Deals high impact damage scaling with DEF."},
		"skillFORTRESS03" = {"skillname" = "Bastion",
			"skilldesc" = "Restores HP to target party member. Amount healed scales with DEF."},
		"skillFORTRESS04" = {"skillname" = "Embolden",
			"skilldesc" = "Boosts the DEF stat for 3 turns."},
		"skillFORTRESS05" = {"skillname" = "Skull Splitter",
			"skilldesc" = "COST '1 Ire' - An overhead strike. Has a chance to stun an enemy."}
		}
	super.GetSkills()

func Turn():
	super.Turn() #calls the parent Turn function. 
	PASSIVE_accumulate_ire = false #reset ire accumulation

func Defend():
	super.Defend()
	PASSIVE_accumulate_ire = true

func take_damage(damage, type):
	if PASSIVE_accumulate_ire == true: 
		ire += 1
		CombatGUI.BattleLog(charname + "'s Ire rises... Current Ire is " + str(ire))
	
	var adjusteddamage = super.take_damage(damage, type)
	return int(adjusteddamage)

func Taunt():
	if MPCheck(10) == "fail": return
	else: CombatGUI.QueueAction(self, "Taunt2")
func Taunt2():
	var previousvalue = statres["marked"]
	statres["marked"] = 0
	if not status.has("marked"):
		AttemptStatusAilment("marked", 80, 2, 0)
	statres["marked"] = previousvalue
	HATE += 50
	MPCost(10)
	CloseTurn(str(charname) + " draws enemy attention!")

func Vanguard():
	if MPCheck(40) == "fail": return
	else: CombatGUI.TargetList("Vanguard2")
func Vanguard2(target):
	var damage = stats["DEF"] * statmods["DEF"]
	var adjusteddamage = target.take_damage(damage, "impact")
	MPCost(40)
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")

func Bastion():
	if MPCheck(40) == "fail": return
	else: CombatGUI.AllyTargetList("Bastion2")
func Bastion2(target):
	var heal = 2 * stats["DEF"]
	target.get_healed(heal)
	MPCost(40)
	CloseTurn(str(charname) + " provides shelter behind her shields to " + str(target.charname) + ", healing her for " + str(heal) + " HP!")

func Embolden():
	if MPCheck(20) == "fail": return
	else: CombatGUI.QueueAction(self, "Embolden2")
func Embolden2():
	MPCost(20)
	StatMod("DEF", 1.25, 2)
	CloseTurn(str(charname) + " takes on a defensive stances! DEF Increased.")

func SkullSplitter():
	if ire == 0:
		CombatGUI.BattleLog("Need Ire to perform this action!")
		return
	else: CombatGUI.TargetList("SkullSplitter2")
func SkullSplitter2(target):
	var damage = stats["DEF"] * statmods["DEF"] + stats["STR"] * statmods["STR"]
	var adjusteddamage = target.take_damage(damage, "impact")
	ire -= 1
	CloseTurn(str(charname) + " uses Ire to perform a crushing overhead blow! to " + str(target.charname) + ", dealing" + str(adjusteddamage) + " damage!")
	target.AttemptStatusAilment("stun", 0, 0, 20)
