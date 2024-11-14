extends Entity

var starting_stats = {
		stat.HP: 80,
		stat.MAXHP: 80,
		stat.MP: 120,
		stat.MAXMP: 120,
		stat.STR: 70,
		stat.DEX: 70,
		stat.DEF: 50,
		stat.INT: 25,
		stat.FTH: 60,
		stat.RES: 50,
		stat.EVD: 80,
		stat.ACC: 70,
		stat.SPD: 60
		}

var stat_scaling = {
		stat.MAXHP: "A",
		stat.MAXMP: "B",
		stat.STR: "D",
		stat.DEX: "D",
		stat.DEF: "B",
		stat.INT: "A",
		stat.FTH: "B",
		stat.RES: "B",
		stat.EVD: "S",
		stat.ACC: "B",
		stat.SPD: "S"
}

var job_description = "The Illusionist Vocation channels the art of silver mist to protect the party with high Evasion. \n\nFocusing on a variety of ways to confuse enemies and help the party avoid fatal blows, the Illusionist is an unconventional, but highly effective tank in the right encounter. Evading attacks grants the Illusionist a resource called [b]Deceit[/b] which allows for the execution of potent Confusing abilities. \n\nEnemies that are highly resistant to blind or confusion may have an easier time finding their mark against an Illusionist."

func _ready():
	charname = "Illusionist"
	HATE = 60
	enemy = false
	weapontype = damage_type.SLASH
	
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
		if n.stats[stat.HP] != 0: n.StatMod(stat.EVD, 1.25, 2)
	CloseTurn(str(charname) + "'s Black Mist billows across the battlefield. Evasion increased!")
  
