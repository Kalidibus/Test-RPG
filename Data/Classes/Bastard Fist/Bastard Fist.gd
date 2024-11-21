extends Entity
#PASSIVES

#STATS
var starting_stats = {
		stat.HP: 100,
		stat.MP: 80,
		stat.MAXHP: 100,
		stat.MAXMP: 80,
		stat.STR: 70,
		stat.DEX: 50,
		stat.DEF: 20,
		stat.INT: 20,
		stat.FTH: 30,
		stat.RES: 50,
		stat.ACC: 40,
		stat.EVD: 40,
		stat.SPD: 70,
		stat.CRIT: 10,
		stat.CRITDMG: 1.5
		}
var stat_scaling = {
		stat.HP: stat_scale.B,
		stat.MP: stat_scale.C,
		stat.MAXHP: stat_scale.B,
		stat.MAXMP: stat_scale.C,
		stat.STR: stat_scale.A,
		stat.DEX: stat_scale.B,
		stat.DEF: stat_scale.B,
		stat.INT: stat_scale.D,
		stat.FTH: stat_scale.D,
		stat.RES: stat_scale.C,
		stat.ACC: stat_scale.B,
		stat.EVD: stat_scale.B,
		stat.SPD: stat_scale.A,
		stat.CRIT: stat_scale.F,
		stat.CRITDMG: stat_scale.F,
		stat.HATE: stat_scale.C
	}
var job_description = "In a flury of crushing blows, the Bastard Fist Vocation unleashes hell with it's massive gauntlets. \n\nSpecializing in combination attacks, Bastard Fists become stronger with repeated attacks. They also boast impressive self buffing capabilities. \n\nTheir buffs often come at a cost however, granting incredible damage at the cost of Defense or Health."

func _ready():
	HATE = 50
	weapontype = damage_type.IMPACT
	
	skill_list = {
		"skillBFIST01" = {skill.name: "Crimson Rush",
			skill.desc: "Strikes an opponent with a flurry of blows. Scales with SPD and STR"},
		"skillBFIST02" = {skill.name: "Scarlet Sun",
			skill.desc: "COMBO: Crimson Rush - A powerful single blow"},
		"skillBFIST03" = {skill.name: "Vermillion Dance",
			skill.desc: "COMBO: Scarlet Sun - This final formation unleashes the true power of the Bastard Fists"},
		"skillBFIST04" = {skill.name: "Bastard Spirit",
			skill.desc: "Raises STR for 3 turns."},
		"skillBFIST05" = {skill.name: "Lunatic Spirit",
			skill.desc: "Greatly raises STR and SPD for 3 turns, but reduces DEF."},
		"skillBFIST06" = {skill.name: "Shear Grit",
			skill.desc: "Recover a percentage of missing health."}
		}

#SKILLS
func CrimsonRush():
	if MPCheck(15) == false: return
	else: CombatGUI.TargetList("CrimsonRush2")
func CrimsonRush2(target):
	var damage = (stats[stat.STR] + stats[stat.SPD])/4
	combo = "CrimsonRush"
	MPCost(15)
	for number in range(3):
		var adjusteddamage = target.take_damage(damage, damage_type.IMPACT)
		CombatGUI.BattleLog(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")
		await get_tree().create_timer(0.5).timeout
	CloseTurn("")

func BastardSpirit():
	if MPCheck(15) == false: return
	else: CombatGUI.QueueAction(self, "BastardSpirit2")
func BastardSpirit2():
	MPCost(15)
	StatMod(stat.STR, 1.25, 2)
	CloseTurn(str(charname) + " draws upon her Bastard Spirit. STR Increased.")

func LunaticSpirit():
	if MPCheck(20) == false: return
	else: CombatGUI.QueueAction(self, "LunaticSpirit2")
func LunaticSpirit2():
	MPCost(20)
	StatMod(stat.STR, 1.5, 2)
	StatMod(stat.SPD, 1.5, 2)
	StatMod(stat.DEF, 0.6, 2)
	CloseTurn(str(charname) + " draws upon her Lunatic Spirit. STR and SPD Increased! DEF Decreased.")

func ScarletSun():
	if combo != "CrimsonRush":
		CombatGUI.BattleLog("Combo not ready!")
		return
	if MPCheck(20) == false: return
	else: CombatGUI.TargetList("ScarletSun2")
func ScarletSun2(target):
	var damage = stats[stat.STR] + stats[stat.SPD]* 1.2
	var adjusteddamage = target.take_damage(damage, damage_type.IMPACT)
	MPCost(20)
	combo = "ScarletSun"
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")

func VermillionDance():
	if combo != "ScarletSun":
		CombatGUI.BattleLog("Combo not ready!")
		return
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "VermillionDance2")
func VermillionDance2():
	MPCost(30)
	var enemies = get_enemy_targets()
	var damage = stats[stat.STR] + stats[stat.SPD] * 1.3
	CombatGUI.BattleLog(str(charname) + " unleashes the Vermillion Dance!")
	for target in enemies:
		if target.stats[stat.HP] != 0:
			var adjusteddamage = target.take_damage(damage, damage_type.IMPACT)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	combo = ""
	CloseTurn("The dance ends...")

func ShearGrit():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "ShearGrit2")
func ShearGrit2():
	get_healed(stats[stat.MAXHP] * 0.5)
	MPCost(30)
	CloseTurn(str(charname) + " grits her teeth through the pain. HP recovered!")
