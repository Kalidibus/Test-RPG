extends Entity

enum skillid {Fort00, Fort01, Fort02, Fort03, Fort04, Fort05, Fort06, Fort07, Fort08, Fort09, Fort10, Fort11, Fort12, Fort13, Fort14, Fort15, Fort16, Fort17, Fort18, Fort19, Fort20, Fort21, Fort22, Fort23, Fort24, Fort25}

#PASSIVES
var PASSIVE_accumulate_ire = true
var ire = 0
var passive_check = false

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
		skillid.Fort00: {skill.name: "Peerless Defenses",
			skill.desc: "PASSIVE - Increases base HATE, and DEF.",
			skill.passive: true,
			skill.max_level: 10,
			skill.parent_unlock_level: 0,
			skill.current_level: 0},
		skillid.Fort01: {skill.name: "Taunt",
			skill.desc: "Marks self, increasing odds of enemies targetting Fortress. Also increases base aggro.",
			skill.max_level: 3,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Fort02: {skill.name: "Vanguard",
			skill.desc: "A savage blow with both shields. Deals high impact damage scaling with DEF.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Fort03: {skill.name: "Bastion",
			skill.desc: "Restores HP to target party member. Amount healed scales with DEF.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Fort04: {skill.name: "Embolden",
			skill.desc: "Boosts the DEF stat for 3 turns.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Fort05: {skill.name: "Shield Tremor",
			skill.desc: "Smashing shields into the ground destablizes the enemy, reducing STR.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Fort06: {skill.name: "Full Cover",
			skill.desc: "Increases Defense of the Front Line",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Fort07: {skill.name: "Skull Splitter",
			skill.desc: "COST '1 Ire' - An overhead strike. Has a chance to stun an enemy.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Fort08: {skill.name: "Vanguard Crush",
			skill.desc: "COST '1 Ire' - A crushing blow from dual shields. Deals heavy damage scaling off of DEF.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Fort09: {skill.name: "Shrapnel Burst",
			skill.desc: "COST '2 Ire' - An explosive blast of rubble that damages the entire enemy front line.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Fort10: {skill.name: "Debilatio",
			skill.desc: "COST '3 Ire' - The destructive ultimate potential of the Fortress. Massive Impact damage to the entire enemy party. Scales off of DEF.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Fort11: {skill.name: "Perfect Shell",
			skill.desc: "Defend and massively increase damage resistance this turn.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0}
		}

#SKILLS
func Turn():
	Passives()
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

func Passives():
	if passive_check == false:
		passive_check = true
		if current_skills.has(skillid.Fort00):
			PeerlessDefenses()

func PeerlessDefenses():
	stats[stat.DEF] = stats[stat.DEF] * (1 + 0.1 * skill_list[skillid.Fort01][skill.current_level])
	stats[stat.HATE] = stats[stat.HATE] * (1 + 0.1 * skill_list[skillid.Fort01][skill.current_level])

func Taunt():
	if MPCheck(10) == false: return
	else: CombatGUI.QueueAction(self, "Taunt2")
func Taunt2():
	var previousvalue = statres[status_effects.MARKED]
	statres[status_effects.MARKED] = 0
	if not status.has(status_effects.MARKED):
		AttemptStatusAilment(status_effects.MARKED, 80, 2, 0)
	statres[status_effects.MARKED] = previousvalue
	HATE += (25 + (25 * skill_list[skillid.Fort01][skill.current_level]))

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
