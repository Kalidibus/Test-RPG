extends Entity

enum skillid {Fort01, Fort02, Fort03, Fort04, Fort05, Fort06, Fort07, Fort08, Fort09, Fort10, Fort11, Fort12, Fort13, Fort14, Fort15, Fort16, Fort17, Fort18, Fort19, Fort20, Fort21, Fort22, Fort23, Fort24, Fort25}

#PASSIVES
var PASSIVE_accumulate_ire = true
var ire = 0

#STATS
var starting_stats = {
		stat.HP: 24,
		stat.MAXHP: 24,
		stat.MP: 50,
		stat.MAXMP: 50,
		stat.STR: 8,
		stat.DEX: 6,
		stat.DEF: 10,
		stat.INT: 7,
		stat.FTH: 7,
		stat.RES: 6,
		stat.EVD: 6,
		stat.ACC: 20,
		stat.SPD: 25,
		stat.CRIT: 10,
		stat.CRITDMG: 1.5
		}
var stat_scaling = {
		stat.HP: stat_scale.A,
		stat.MP: stat_scale.C,
		stat.MAXHP: stat_scale.A,
		stat.MAXMP: stat_scale.C,
		stat.STR: stat_scale.B,
		stat.DEX: stat_scale.D,
		stat.DEF: stat_scale.S,
		stat.INT: stat_scale.C,
		stat.FTH: stat_scale.C,
		stat.RES: stat_scale.B,
		stat.EVD: stat_scale.D,
		stat.ACC: stat_scale.C,
		stat.SPD: stat_scale.D,
		stat.CRIT: stat_scale.F,
		stat.CRITDMG: stat_scale.F,
		stat.HATE: stat_scale.S
	}
var job_description = "An iron wall to keep Lamentations at bay. \n\nThe Fortress vocation excels at defending the party from physical attacks. Taking hits from enemies repeatedly will also accumulate a resource called [b]Ire[/b] which can be used to trigger powerful counter-attacks. \n\nWhile the Fortresses' shields can protect against magic attacks to some degree, they are not as well suited for foes that deal elemental damage."

func _ready():
	HATE = 100
	weapontype = damage_type.IMPACT
	
	skill_list = {
		skillid.Fort01: {"skillname" = "Taunt",
			"skilldesc" = "Marks self, increasing odds of enemies targetting Fortress. Also increases base aggro.",
			"max_level" = 5,
			"current_level" = 0},
		skillid.Fort02: {"skillname" = "Vanguard",
			"skilldesc" = "A savage blow with both shields. Deals high impact damage scaling with DEF.",
			"max_level" = 5,
			"current_level" = 0},
		skillid.Fort03: {"skillname" = "Bastion",
			"skilldesc" = "Restores HP to target party member. Amount healed scales with DEF.",
			"max_level" = 5,
			"current_level" = 0},
		skillid.Fort04: {"skillname" = "Embolden",
			"skilldesc" = "Boosts the DEF stat for 3 turns.",
			"max_level" = 5,
			"current_level" = 0},
		skillid.Fort05: {"skillname" = "Shield Tremor",
			"skilldesc" = "Smashing shields into the ground destablizes the enemy, reducing STR.",
			"max_level" = 5,
			"current_level" = 0},
		skillid.Fort06: {"skillname" = "Full Cover",
			"skilldesc" = "Increases Defense of the Front Line",
			"max_level" = 5,
			"current_level" = 0},
		skillid.Fort07: {"skillname" = "Skull Splitter",
			"skilldesc" = "COST '1 Ire' - An overhead strike. Has a chance to stun an enemy.",
			"max_level" = 5,
			"current_level" = 0},
		skillid.Fort08: {"skillname" = "Vanguard Crush",
			"skilldesc" = "COST '1 Ire' - A crushing blow from dual shields. Deals heavy damage scaling off of DEF.",
			"max_level" = 5,
			"current_level" = 0},
		skillid.Fort09: {"skillname" = "Shrapnel Burst",
			"skilldesc" = "COST '2 Ire' - An explosive blast of rubble that damages the entire enemy front line.",
			"max_level" = 5,
			"current_level" = 0},
		skillid.Fort10: {"skillname" = "Debilatio",
			"skilldesc" = "COST '3 Ire' - The destructive ultimate potential of the Fortress. Massive Impact damage to the entire enemy party. Scales off of DEF.",
			"max_level" = 5,
			"current_level" = 0},
		skillid.Fort11: {"skillname" = "Perfect Shell",
			"skilldesc" = "Defend and massively increase damage resistance this turn.",
			"max_level" = 5,
			"current_level" = 0}
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
	if MPCheck(10) == false: return
	else: CombatGUI.QueueAction(self, "Taunt2")
func Taunt2():
	var previousvalue = statres[status_effects.MARKED]
	statres[status_effects.MARKED] = 0
	if not status.has(status_effects.MARKED):
		AttemptStatusAilment(status_effects.MARKED, 80, 2, 0)
	statres[status_effects.MARKED] = previousvalue
	print(str(HATE))
	print(str(skill_list[skillid.Fort01]["current_level"]))
	HATE += (25 + (25 * skill_list[skillid.Fort01]["current_level"]))
	print(str(HATE))
	MPCost(10)
	CloseTurn(str(charname) + " Taunts the enemy!")

func Vanguard():
	if MPCheck(40) == false: return
	else: CombatGUI.TargetList("Vanguard2")
func Vanguard2(target):
	var damage = stats[stat.DEF] * statmods[stat.DEF]
	var adjusteddamage = target.take_damage(damage, damage_type.IMPACT)
	MPCost(40)
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")

func Bastion():
	if MPCheck(40) == false: return
	else: CombatGUI.AllyTargetList("Bastion2")
func Bastion2(target):
	var heal = 2 * stats[stat.DEF]
	target.get_healed(heal)
	MPCost(40)
	CloseTurn(str(charname) + " provides shelter behind her shields to " + str(target.charname) + ", healing her for " + str(heal) + " HP!")

func Embolden():
	if MPCheck(20) == false: return
	else: CombatGUI.QueueAction(self, "Embolden2")
func Embolden2():
	MPCost(20)
	StatMod(stat.DEF, 1.25, 2)
	CloseTurn(str(charname) + " takes on a defensive stances! DEF Increased.")

func VanguardCrush():
	if ire == 0:
		CombatGUI.BattleLog("Not enough Ire to perform this action!")
		return
	else: CombatGUI.TargetList("VanguardCrush2")
func VanguardCrush2(target):
	var damage_dealt = Damage(target, Stat(stat.DEF) * 1.5, damage_type.IMPACT)
	MPCost(40)
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(damage_dealt) + " damage!")

func SkullSplitter():
	if ire == 0:
		CombatGUI.BattleLog("Not enough Ire to perform this action!")
		return
	else: CombatGUI.TargetList("SkullSplitter2")
func SkullSplitter2(target):
	var damage = stats[stat.DEF] * statmods[stat.DEF] + stats[stat.STR] * statmods[stat.STR]
	var adjusteddamage = target.take_damage(damage, damage_type.IMPACT)
	ire -= 1
	CloseTurn(str(charname) + " uses Ire to perform a crushing overhead blow! to " + str(target.charname) + ", dealing" + str(adjusteddamage) + " damage!")
	target.AttemptStatusAilment(status_effects.STUN, 0, 0, 20)

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
		if target.stats[stat.HP] != 0 and target.row == row_line.FRONT:
			var damage_dealt = Damage(target, Stat(stat.DEF) * 1.2, damage_type.IMPACT)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(damage_dealt) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("")

func ShieldTremor():
	if MPCheck(20) == false: return
	else: CombatGUI.QueueAction(self, "ShieldTremor2")
func ShieldTremor2():
	var enemies = get_enemy_targets()
	CombatGUI.BattleLog(str(charname) + " smashes her shields into the ground, destabilizing enemy lines!")
	for target in enemies:
		if target.stats[stat.HP] != 0:
			var damage_dealt = Damage(target, Stat(stat.DEF)/0.5, damage_type.IMPACT)
			target.StatMod(stat.STR, 30, 1)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(damage_dealt) + " damage! STR Decreased!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("")

func FullCover():
	if MPCheck(20) == false: return
	else: CombatGUI.QueueAction(self, "FullCover2")
func FullCover2():
	var party = get_party_targets()
	for n in party:
		if n.row ==row_line.FRONT: StatMod(stat.DEF, 1.6, 1)
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
		if target.stats[stat.HP] != 0:
			var damage_dealt = Damage(target, Stat(stat.DEF) * 1.8, damage_type.IMPACT)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(damage_dealt) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("")

func PerfectShell():
	if MPCheck(50) == false: return
	else: CombatGUI.QueueAction(self, "PerfectShell2")
func PerfectShell2():
		StatMod(stat.DEF, 999, 1)
		StatMod(stat.RES, 999, 1)
		CombatGUI.BattleLog(str(charname) + " uses Perfect Shell!")
		super.Defend()
		CloseTurn("")
