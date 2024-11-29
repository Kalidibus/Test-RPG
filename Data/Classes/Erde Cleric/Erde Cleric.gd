extends Entity

enum skillid {Erde00, Erde01, Erde02, Erde03, Erde04, Erde05, Erde06, Erde07, Erde08, Erde09, Erde10, Erde11, Erde12, Erde13, Erde14, Erde15, Erde16, Erde17, Erde18, Erde19, Erde20 }

#PASSIVES

#STATS
var starting_stats = {
		stat.HP: 75,
		stat.MAXHP: 75,
		stat.MP: 125,
		stat.MAXMP: 125,
		stat.STR: 45,
		stat.DEX: 20,
		stat.DEF: 50,
		stat.INT: 75,
		stat.FTH: 125,
		stat.RES: 100,
		stat.ACC: 50,
		stat.EVD: 20,
		stat.SPD: 75,
		stat.CRIT: 10,
		stat.CRITDMG: 1.5
	}
var stat_scaling = {
		stat.HP: stat_scale.B,
		stat.MP: stat_scale.A,
		stat.MAXHP: stat_scale.B,
		stat.MAXMP: stat_scale.A,
		stat.STR: stat_scale.A,
		stat.DEX: stat_scale.C,
		stat.DEF: stat_scale.C,
		stat.INT: stat_scale.B,
		stat.FTH: stat_scale.S,
		stat.RES: stat_scale.S,
		stat.ACC: stat_scale.B,
		stat.EVD: stat_scale.B,
		stat.SPD: stat_scale.B,
		stat.CRIT: stat_scale.F,
		stat.CRITDMG: stat_scale.F,
		stat.HATE: stat_scale.D
	}
var job_description = "The Erde Cleric is a healer capable of powerful restorations. \n\nThe party can safely soak massive damage with minimal fear while an Erde Cleric is present, as they are one of the most powerful healing Vocations known. \n\nTheir high focus on healing leaves them unable to contribute much to offense."

func _ready():
	HATE = 50
	weapontype = damage_type.IMPACT
	
	skill_list = {
		skillid.Erde01: {skill.name: "Bounty",
			skill.desc: "Heals an allied unit.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Erde02: {skill.name: "Full Blessing",
			skill.desc: "Heals the party.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Erde03: {skill.name: "Divine Bolt",
			skill.desc: "A modest bolt of light, damages a single enemy.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Erde05: {skill.name: "Natural Revile",
			skill.desc: "Unleashes a swarm of roots, damaging enemies and reducing their speed.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Erde04: {skill.name: "Resurrect",
			skill.desc: "Raises one ally from the dead.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0}
		}

#SKILLS
func Bounty():
	if MPCheck(10) == false: return
	else: CombatGUI.AllyTargetList("Bounty2")
func Bounty2(target):
	if target.stats[stat.HP] == 0:
		CombatGUI.BattleLog("This target must be raised from the dead first")
		return
	var heal = Stat(stat.FTH) * 4 * (1 + (0.1 * skill_list[skillid.Erde01][skill.current_level]))
	target.get_healed(heal)
	MPCost(10)
	CloseTurn(str(charname) + " blesses " + str(target.charname) + " with the bounty of the forest, healing her for " + str(heal) + " HP!")

func FullBlessing():
	if MPCheck(50) == false: return
	else: CombatGUI.QueueAction(self, "FullBlessing2")
func FullBlessing2():
	var partylist = get_party_targets()
	MPCost(50)
	for n in partylist:
		if n.stats[stat.HP] != 0:
			n.get_healed(Stat(stat.FTH))
	CloseTurn(str(charname) + " Restores the parties health for " + str(Stat(stat.FTH)) + "!")

func DivineBolt():
	if MPCheck(10) == false: return
	CombatGUI.TargetList("DivineBolt2")
func DivineBolt2(target):
	var damage_dealt = Damage(target, Stat(stat.FTH), damage_type.VIRTUOS)
	MPCost(10)
	CloseTurn(str(charname) + " launches an divine bolt of cleansing magic at " + str(target.charname) + ", hitting it for " + str(damage_dealt) + " damage!")

func Resurrect():
	if MPCheck(50) == false: return
	else: CombatGUI.AllyTargetList("Raise")
func Raise(target): #any function that revives needs to be called Raise so it doesn't get canceled by the auto-queue
	if target.stats[stat.HP] != 0:
		CloseTurn(str(target.charname) + " is not dead!")
	else:
		var heal =  Stat(stat.FTH) * 4 * (1 + (0.1 *skill_list[skillid.Erde04][skill.current_level]))
		Revive(target, heal)
		MPCost(50)
		CloseTurn(str(charname) + " blesses " + str(target.charname) + " with the bounty of the forest, healing her for " + str(heal) + " HP!")

func NaturalRevile():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "NaturalRevile2")
func NaturalRevile2():
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " unleashes a swarm of roots!")
	for target in enemies:
		if target.stats[stat.HP] != 0:
			var adjusteddamage = Damage(target, stat.FTH / 2, damage_type.ERDE)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			target.StatMod(stat.SPD, 0.6, 3)
			await get_tree().create_timer(0.5).timeout
	CloseTurn("")
