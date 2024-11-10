extends Entity
#PASSIVES

#STATS
var starting_stats = {
		"HP" = 75,
		"HPmax" = 75,
		"MP" = 125,
		"MPmax" = 125,
		"STR" = 45,
		"DEX" = 20,
		"DEF" = 50,
		"INT" = 75,
		"FTH" = 125,
		"RES" = 100,
		"ACC" = 50,
		"EVD" = 20,
		"SPD" = 75
	}
var stat_scaling = {
		"HPmax" = "B",
		"MPmax" = "A",
		"STR" = "A",
		"DEX" = "C",
		"DEF" = "C",
		"INT" = "B",
		"FTH" = "S",
		"RES" = "S",
		"ACC" = "B",
		"EVD" = "B",
		"SPD" = "B"
	}
var job_description = "The Erde Cleric is a healer capable of powerful restorations. \n\nThe party can safely soak massive damage with minimal fear while an Erde Cleric is present, as they are one of the most powerful healing Vocations known. \n\nTheir high focus on healing leaves them unable to contribute much to offense."

func _ready():
	HATE = 50
	weapontype = "impact"
	
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
	if MPCheck(10) == "fail": return
	else: CombatGUI.AllyTargetList("Bounty2")
func Bounty2(target):
	if target.stats["HP"] == 0:
		CombatGUI.BattleLog("This target must be raised from the dead first")
		return
	var heal = Stat("FTH")
	target.get_healed(heal)
	MPCost(10)
	CloseTurn(str(charname) + " blesses " + str(target.charname) + " with the bounty of the forest, healing her for " + str(heal) + " HP!")

func FullBlessing():
	if MPCheck(50) == "fail": return
	else: CombatGUI.QueueAction(self, "FullBlessing2")
func FullBlessing2():
	var partylist = get_party_targets()
	MPCost(50)
	for n in partylist:
		if n.HP != 0:
			n.get_healed(Stat("FTH"))
	CloseTurn(str(charname) + " Restores the parties health for " + str(stats["FTH"]) + "!")

func DivineBolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("DivineBolt2")
func DivineBolt2(target):
	var damage_dealt = Damage(target, Stat("FTH"), "virtuos")
	MPCost(10)
	CloseTurn(str(charname) + " launches an divine bolt of cleansing magic at " + str(target.charname) + ", hitting it for " + str(damage_dealt) + " damage!")

func Resurrect():
	if MPCheck(50) == "fail": return
	else: CombatGUI.AllyTargetList("Raise")
func Raise(target): #any function that revives needs to be called Raise so it doesn't get canceled by the auto-queue
	if target.stats["HP"] != 0:
		CloseTurn(str(target.charname) + " is not dead!")
	else:
		var heal = Stat("FTH")
		target.get_healed(heal)
		target.dead = false
		MPCost(50)
		CloseTurn(str(charname) + " blesses " + str(target.charname) + " with the bounty of the forest, healing her for " + str(heal) + " HP!")
