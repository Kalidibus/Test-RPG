extends Entity

var starting_stats = {
		"HP" = 75,
		"MP" = 125,
		"STR" = 25,
		"DEF" = 50,
		"INT" = 75,
		"FTH" = 125,
		"RES" = 100,
		"EVD" = 20,
		"SPD" = 75
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

var job_description = "The Erde Cleric is a healer capable of powerful restorations. \n\nThe party can safely soak massive damage with minimal fear while an Erde Cleric is present, as they are one of the most powerful healing Vocations known. \n\nTheir high focus on healing leaves them unable to contribute much to offense."

func _ready():
	charname = "Cleric"
	HATE = 50
	enemy = false
	weapontype = "impact"
	
	skill_list = {
		"Bounty" : "Heals an allied unit",
		"Full Blessing" : "Heals the party",
		"Divine Bolt" : "A modest bolt of light, damages a single enemy",
		"Resurrect" : "Raises one ally from the dead"
	}

func Bounty():
	if MPCheck(10) == "fail": return
	else: CombatGUI.AllyTargetList("Bounty2")
func Bounty2(target):
	if target.HP == 0:
		CombatGUI.BattleLog("This target must be raised from the dead first")
		return
	var heal = stats["FTH"]
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
			n.get_healed(stats["FTH"])
	CloseTurn(str(charname) + " Restores the parties health for " + str(stats["FTH"]) + "!")

func DivineBolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("DivineBolt2")
func DivineBolt2(target):
	var damage = stats["INT"] * statmods["INT"]
	target.take_damage(damage, "virtuos")
	MPCost(10)
	CloseTurn(str(charname) + " launches an divine bolt of cleansing magic at " + str(target.charname) + ", hitting it for " + str(damage) + " damage!")

func Resurrect():
	if MPCheck(50) == "fail": return
	else: CombatGUI.AllyTargetList("Raise")
func Raise(target): #any function that revives needs to be called Raise so it doesn't get canceled by the auto-queue
	if target.HP != 0:
		CloseTurn(str(target.charname) + " is not dead!")
	else:
		var heal = stats["FTH"]
		target.get_healed(heal)
		target.dead = false
		MPCost(50)
		CloseTurn(str(charname) + " blesses " + str(target.charname) + " with the bounty of the forest, healing her for " + str(heal) + " HP!")
