extends Entity

#PASSIVES
var PASSIVE_accumulate_ire = true
var ire = 0

#STATS
var starting_stats = {
		"HP" = 125,
		"HPmax" = 125,
		"MP" = 50,
		"MPmax" = 50,
		"STR" = 50,
		"DEX" = 20,
		"DEF" = 75,
		"INT" = 25,
		"FTH" = 50,
		"RES" = 50,
		"EVD" = 20,
		"ACC" = 20,
		"SPD" = 25
		}
var stat_scaling = {
		"HPmax" = "A",
		"MPmax" = "C",
		"STR" = "B",
		"DEX" = "D",
		"DEF" = "S",
		"INT" = "C",
		"FTH" = "C",
		"RES" = "B",
		"EVD" = "D",
		"ACC" = "C",
		"SPD" = "D"
	}
var job_description = "An iron wall to keep Lamentations at bay. \n\nThe Fortress vocation excels at defending the party from physical attacks. Taking hits from enemies repeatedly will also accumulate a resource called [b]Ire[/b] which can be used to trigger powerful counter-attacks. \n\nWhile the Fortresses' shields can protect against magic attacks to some degree, they are not as well suited for foes that deal elemental damage."

func _ready():
	HATE = 100
	weapontype = "impact"
	
	skill_list = {
		"skillFORTRESS01" = {"skillname" = "Taunt",
			"skilldesc" = "Marks self, increasing odds of enemies targetting Fortress. Also increases base aggro."},
		"skillFORTRESS02" = {"skillname" = "Vanguard",
			"skilldesc" = "A savage blow with both shields. Deals high impact damage scaling with DEF."},
		"skillFORTRESS03" = {"skillname" = "Bastion",
			"skilldesc" = "Restores HP to target party member. Amount healed scales with DEF."},
		"skillFORTRESS04" = {"skillname" = "Embolden",
			"skilldesc" = "Boosts the DEF stat for 3 turns."},
		"skillFORTRESS05" = {"skillname" = "Shield Tremor",
			"skilldesc" = "Smashing shields into the ground destablizes the enemy, reducing STR."},
		"skillFORTRESS06" = {"skillname" = "Full Cover",
			"skilldesc" = "Increases Defense of the Front Line"},
		"skillFORTRESS07" = {"skillname" = "Skull Splitter",
			"skilldesc" = "COST '1 Ire' - An overhead strike. Has a chance to stun an enemy."},
		"skillFORTRESS08" = {"skillname" = "Vanguard Crush",
			"skilldesc" = "COST '1 Ire' - A crushing blow from dual shields. Deals heavy damage scaling off of DEF."},
		"skillFORTRESS09" = {"skillname" = "Shrapnel Burst",
			"skilldesc" = "COST '2 Ire' - An explosive blast of rubble that damages the entire enemy front line."},
		"skillFORTRESS10" = {"skillname" = "Debilatio",
			"skilldesc" = "COST '3 Ire' - The destructive ultimate potential of the Fortress. Massive Impact damage to the entire enemy party. Scales off of DEF."},
		"skillFORTRESS11" = {"skillname" = "Perfect Shell",
			"skilldesc" = "Defend and massively increase damage resistance this turn."}
		}

#SKILLS
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

func VanguardCrush():
	if ire == 0:
		CombatGUI.BattleLog("Need Ire to perform this action!")
		return
	else: CombatGUI.TargetList("VanguardCrush2")
func VanguardCrush2(target):
	var damage_dealt = Damage(target, Stat("DEF") * 1.5, "impact")
	MPCost(40)
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(damage_dealt) + " damage!")

func SkullSplitter():
	if ire == 0:
		CombatGUI.BattleLog("Not enough Ire to perform this action!")
		return
	else: CombatGUI.TargetList("SkullSplitter2")
func SkullSplitter2(target):
	var damage = stats["DEF"] * statmods["DEF"] + stats["STR"] * statmods["STR"]
	var adjusteddamage = target.take_damage(damage, "impact")
	ire -= 1
	CloseTurn(str(charname) + " uses Ire to perform a crushing overhead blow! to " + str(target.charname) + ", dealing" + str(adjusteddamage) + " damage!")
	target.AttemptStatusAilment("stun", 0, 0, 20)

func ShrapnelBurst():
	if ire < 2:
		CombatGUI.BattleLog("Not enough Ire to perform this action!")
		return
	else: CombatGUI.QueueAction(self, "ShrapnelBurst2")
func ShrapnelBurst2():
	var enemies = get_enemy_targets()
	ire -= 2
	CombatGUI.BattleLog(str(charname) + " unleashes a burst of Shrapnel to the enemy front line!")
	
	for target in enemies:
		if target.stats["HP"] != 0 and target.row == "front":
			var damage_dealt = Damage(target, Stat("DEF") * 1.2, "impact")
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(damage_dealt) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("")

func ShieldTremor():
	if MPCheck(20) == "fail": return
	else: CombatGUI.QueueAction(self, "ShieldTremor2")
func ShieldTremor2():
	var enemies = get_enemy_targets()
	CombatGUI.BattleLog(str(charname) + " smashes her shields into the ground, destabilizing enemy lines!")
	for target in enemies:
		if target.stats["HP"] != 0:
			var damage_dealt = Damage(target, Stat("DEF")/0.5, "impact")
			target.StatMod("STR", 30, 1)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(damage_dealt) + " damage! STR Decreased!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("")

func FullCover():
	if MPCheck(20) == "fail": return
	else: CombatGUI.QueueAction(self, "FullCover2")
func FullCover2():
	var party = get_party_targets()
	for n in party:
		if n.row =="front": StatMod("DEF", 1.6, 1)
	CloseTurn(str(charname) + " guards the front row!")

func Debilatio():
	if ire < 3:
		CombatGUI.BattleLog("Not enough Ire to perform this action!")
		return
	else: CombatGUI.QueueAction(self, "Debilatio2")
func Debilatio2():
	var enemies = get_enemy_targets()
	ire -= 3
	CombatGUI.BattleLog(str(charname) + " unleashes Debilatio!")
	
	for target in enemies:
		if target.stats["HP"] != 0:
			var damage_dealt = Damage(target, Stat("DEF") * 1.8, "impact")
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(damage_dealt) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("")

func PerfectShell():
	if MPCheck(50) == "fail": return
	else: CombatGUI.QueueAction(self, "PerfectShell2")
func PerfectShell2():
		StatMod("DEF", 999, 1)
		StatMod("RES", 999, 1)
		CombatGUI.BattleLog(str(charname) + " uses Perfect Shell!")
		super.Defend()
		CloseTurn("")
