extends Entity

var starting_stats = {
		"HP" = 80,
		"MP" = 120,
		"STR" = 70,
		"DEF" = 50,
		"INT" = 25,
		"FTH" = 60,
		"RES" = 50,
		"EVD" = 40,
		"SPD" = 60
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

var job_description = "A whirlwind of blades that bolsters the parties damage. \n\nDancer's are a potent addition to any party, especially those focused on physical damage types. Using a variety of dances, they bolster damage and MP regeneration, or follow up with ally attacks to devestating effect. \n\nThey are less effective at bolstering the abilities of Casters."

func _ready():
	charname = "Dancer"
	HATE = 60
	enemy = false
	weapontype = "slash"
	
	skill_list = {
		"Raptor Samba" : "Increases Party-wide Strength",
		"Soothing Waltz" : "Applies a regen effect to the whole party.",
		"Invigorating Galliard" : "Increases Party-wide Speed",
		"Whirling Blades" : "Slashing damage to all front line enemies."
	}

func RaptorSamba():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "RaptorSamba2")
func RaptorSamba2():
	var partylist = get_party_targets()
	MPCost(30)
	for n in partylist:
		if n.HP != 0: n.StatMod("STR", 1.25, 2)
	CloseTurn(str(charname) + "'s Raptor Samba emboldens the party. Strength increased!")
  
func SoothingWaltz():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "SoothingWaltz2")
func SoothingWaltz2():
	var partylist = get_party_targets()
	MPCost(30)
	for n in partylist:
		if n.HP != 0: n.AttemptStatusAilment("regen", 30, 3, 0)
	CloseTurn(str(charname) + "'s Soothing Waltz begins healing the party!")
   
func InvigoratingGalliard():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "InvigoratingGalliard2")
func InvigoratingGalliard2():
	var partylist = get_party_targets()
	MPCost(30)
	for n in partylist:
		if n.HP != 0: n.StatMod("SPD", 1.25, 2)
	CloseTurn(str(charname) + "'s Invigorating Galliad motivates the party. Speed increased!")

func WhirlingBlades():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "WhirlingBlades2")
func WhirlingBlades2():
	var damage = (stats["STR"] * statmods["STR"])*0.6
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " performs a whirling dance of blades!")
	for target in enemies:
		if target.row == "Front" and target.stats["HP"] != 0:
			var adjusteddamage = target.take_damage(damage, "slash")
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("")
