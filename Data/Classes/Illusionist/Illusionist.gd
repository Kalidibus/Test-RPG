extends Entity

var starting_stats = {
		"HP" = 80,
		"HPmax" = 80,
		"MP" = 120,
		"MPmax" = 120,
		"STR" = 70,
		"DEX" = 70,
		"DEF" = 50,
		"INT" = 25,
		"FTH" = 60,
		"RES" = 50,
		"EVD" = 80,
		"ACC" = 70,
		"SPD" = 60
		}

var stat_scaling = {
		"HPmax" = "A",
		"MPmax" = "B",
		"STR" = "D",
		"DEX" = "D",
		"DEF" = "B",
		"INT" = "A",
		"FTH" = "B",
		"RES" = "B",
		"EVD" = "S",
		"ACC" = "B",
		"SPD" = "S"
}

var job_description = "The Illusionist Vocation channels the art of silver mist to protect the party with high Evasion. \n\nFocusing on a variety of ways to confuse enemies and help the party avoid fatal blows, the Illusionist is an unconventional, but highly effective tank in the right encounter. Evading attacks grants the Illusionist a resource called [b]Deceit[/b] which allows for the execution of potent Confusing abilities. \n\nEnemies that are highly resistant to blind or confusion may have an easier time finding their mark against an Illusionist."

func _ready():
	charname = "Illusionist"
	HATE = 60
	enemy = false
	weapontype = "slash"
	
	skill_list = {
		"skillILLUSIONIST01" = {"skillname" = "Black Mist",
			"skilldesc" = "A black shroud of mist engulfs the battlefield, raising Party Evasion."}
			}

func BlackMist():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "BlackMist2")
func BlackMist2():
	var partylist = get_party_targets()
	MPCost(30)
	for n in partylist:
		if n.stats["HP"] != 0: n.StatMod("EVD", 1.25, 2)
	CloseTurn(str(charname) + "'s Black Mist billows across the battlefield. Evasion increased!")
  
