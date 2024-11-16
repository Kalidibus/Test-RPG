extends Entity
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
		stat.MAXHP: "B",
		stat.MAXMP: "A",
		stat.STR: "A",
		stat.DEX: "C",
		stat.DEF: "C",
		stat.INT: "B",
		stat.FTH: "S",
		stat.RES: "S",
		stat.ACC: "B",
		stat.EVD: "B",
		stat.SPD: "B"
	}
var job_description = "The Erde Cleric is a healer capable of powerful restorations. \n\nThe party can safely soak massive damage with minimal fear while an Erde Cleric is present, as they are one of the most powerful healing Vocations known. \n\nTheir high focus on healing leaves them unable to contribute much to offense."

func _ready():
	HATE = 50
	weapontype = damage_type.IMPACT
	
	skill_list = {
		"skillECLERIC01" = {"skillname" = "Bounty",
			"skilldesc" = "Heals an allied unit."},
		"skillECLERIC02" = {"skillname" = "Full Blessing",
			"skilldesc" = "Heals the party."},
		"skillECLERIC03" = {"skillname" = "Divine Bolt",
			"skilldesc" = "A modest bolt of light, damages a single enemy."},
		"skillECLERIC04" = {"skillname" = "Resurrect",
			"skilldesc" = "Raises one ally from the dead."}
		}

#SKILLS
func Bounty():
	if MPCheck(10) == false: return
	else: CombatGUI.AllyTargetList("Bounty2")
func Bounty2(target):
	if target.stats[stat.HP] == 0:
		CombatGUI.BattleLog("This target must be raised from the dead first")
		return
	var heal = Stat(stat.FTH)
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
		var heal = Stat(stat.FTH)
		Revive(target, heal)
		MPCost(50)
		CloseTurn(str(charname) + " blesses " + str(target.charname) + " with the bounty of the forest, healing her for " + str(heal) + " HP!")
