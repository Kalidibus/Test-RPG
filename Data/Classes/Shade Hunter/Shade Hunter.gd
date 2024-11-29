extends Entity
#PASSIVES
enum skillid {Shad00, Shad01, Shad02, Shad03, Shad04, Shad05, Shad06, Shad07, Shad08, Shad09, Shad10, Shad11, Shad12, Shad13, Shad14, Shad15, Shad16, Shad17, Shad18, Shad19, Shad20 }

#STATS
var starting_stats = {
		stat.HP: 60,
		stat.MP: 60,
		stat.MAXHP: 60,
		stat.MAXMP: 60,
		stat.STR: 50,
		stat.DEX: 80,
		stat.DEF: 20,
		stat.INT: 30,
		stat.FTH: 30,
		stat.RES: 50,
		stat.ACC: 80,
		stat.EVD: 40,
		stat.SPD: 100,
		stat.CRIT: 10,
		stat.CRITDMG: 1.5
	}
var stat_scaling = {
		stat.HP: stat_scale.B,
		stat.MP: stat_scale.B,
		stat.MAXHP: stat_scale.B,
		stat.MAXMP: stat_scale.B,
		stat.STR: stat_scale.C,
		stat.DEX: stat_scale.S,
		stat.DEF: stat_scale.C,
		stat.INT: stat_scale.C,
		stat.FTH: stat_scale.C,
		stat.RES: stat_scale.B,
		stat.ACC: stat_scale.S,
		stat.EVD: stat_scale.A,
		stat.SPD: stat_scale.A,
		stat.CRIT: stat_scale.F,
		stat.CRITDMG: stat_scale.F,
		stat.HATE: stat_scale.D
	}
var job_description = "Striking from the shadows, the Shade Hunter's tainted arrows weaken enemies and leave them vulnerable to ally attacks. \n\nThe Shade Hunter vocation is an excellent addition to parties that need debuffing capabilities to take on stronger foes. In addition, various attacks target the enemy back row effectively, dealing significant damage in groups. A solid unit capable of fitting into most party compositions. \n\nThe Shade Hunter is less effective against units resistant to Burn or Poison."

func _ready():
	HATE = 50
	weapontype = damage_type.PIERCE
	
	skill_list = {
		skillid.Shad01: {skill.name: "Poison Arrow",
			skill.desc: "An arrow dipped in potent venoms. Can inflict Poison.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Shad02: {skill.name: "Burning Arrow",
			skill.desc: "An arrow dipped in molten inferno. Can inflict Burn.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Shad03: {skill.name: "Bladed Volley",
			skill.desc: "Slashing damage to all back line enemies.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Shad04: {skill.name: "Plate Crusher",
			skill.desc: "A single target impact based shot with a chance to reduce enemies DEF.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Shad05: {skill.name: "Isolate Prey",
			skill.desc: "Target weak links in the enemies lines. Moderate piercing damage that scales with SPD. Deal bonus damage for each status ailment on target.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0}
			}

#SKILLS
func PoisonArrow():
	if MPCheck(10) == false: return
	CombatGUI.TargetList("PoisonArrow2")
func PoisonArrow2(target):
	var damage = (stats[stat.SPD] * statmods[stat.SPD])*0.5
	var adjusteddamage = target.take_damage(damage, damage_type.PIERCE)
	MPCost(10)
	CloseTurn(str(charname) + " fires a poison drenched arrow at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")
	target.AttemptStatusAilment(status_effects.POISON, Stat(stat.DEX) * 0.8, 3, 20)

func BurningArrow():
	if MPCheck(10) == false: return
	CombatGUI.TargetList("BurningArrow2")
func BurningArrow2(target):
	var damage = (stats[stat.SPD] * statmods[stat.SPD])*0.5
	var adjusteddamage = target.take_damage(damage, damage_type.PIERCE)
	MPCost(10)
	CloseTurn(str(charname) + " fires a flaming arrow at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")
	target.AttemptStatusAilment(status_effects.BURN, Stat(stat.DEX) * 0.8, 3, 20)
	
func BladedVolley():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "BladedVolley2")
func BladedVolley2():
	var damage = (stats[stat.SPD] * statmods[stat.SPD])*0.6
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " fires a Bladed Volley!")
	for target in enemies:
		if target.row == row_line.BACK and target.stats[stat.HP] != 0:
			var adjusteddamage = target.take_damage(damage, damage_type.SLASH)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("")

func PlateCrusher():
	if MPCheck(20) == false: return
	CombatGUI.TargetList("PlateCrusher2")
func PlateCrusher2(target):
	var adjusteddamage = Damage(target, Stat(stat.DEX)/2 + Stat(stat.SPD)/2, damage_type.IMPACT)
	MPCost(20)
	var rng = Globals.RNG()
	if rng >= 50: 
		target.StatMod(stat.DEF, 0.6, 2)
		CombatGUI.BattleLog(str(charname) + " fires a high impact shot at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")
		CloseTurn(target.charname + "'s Defense is weakened!")
	else: 
		CloseTurn(str(charname) + " fires a high impact shot at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func IsolatePrey():
	if MPCheck(20) == false: return
	CombatGUI.TargetList("IsolatePrey2")
func IsolatePrey2(target):
	var damage = max((stats[stat.SPD] * statmods[stat.SPD])*0.5, (stats[stat.SPD] * statmods[stat.SPD]) * target.status.size())
	var adjusteddamage = target.take_damage(damage, damage_type.PIERCE)
	MPCost(20)
	CloseTurn(str(charname) + " strikes at the vitals of the weakened " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")
