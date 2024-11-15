extends Entity

var starting_stats = {
		stat.HP: 80,
		stat.MP: 120,
		stat.STR: 70,
		stat.DEF: 50,
		stat.INT: 25,
		stat.FTH: 60,
		stat.RES: 50,
		stat.EVD: 40,
		stat.ACC: 40,
		stat.SPD: 60,
		stat.CRIT: 10,
		stat.CRITDMG: 1.5
		}

var stat_scaling = {
		stat.MAXHP: "A",
		stat.MAXMP: "C",
		stat.STR: "B",
		stat.DEF: "S",
		stat.INT: "C",
		stat.FTH: "C",
		stat.RES: "B",
		stat.EVD: "D",
		stat.SPD: "D"
}

var job_description = "A whirlwind of blades that bolsters the parties damage. \n\nDancer's are a potent addition to any party, especially those focused on physical damage types. Using a variety of dances, they bolster damage and MP regeneration, or follow up with ally attacks to devestating effect. \n\nThey are less effective at bolstering the abilities of Casters."

func _ready():
	charname = "Dancer"
	HATE = 60
	enemy = false
	weapontype = damage_type.SLASH
	
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
		if n.HP != 0: n.StatMod(stat.STR, 1.25, 2)
	CloseTurn(str(charname) + "'s Raptor Samba emboldens the party. Strength increased!")
  
func SoothingWaltz():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "SoothingWaltz2")
func SoothingWaltz2():
	var partylist = get_party_targets()
	MPCost(30)
	for n in partylist:
		if n.HP != 0: n.AttemptStatusAilment(status_effects.REGEN, 30, 3, 0)
	CloseTurn(str(charname) + "'s Soothing Waltz begins healing the party!")
   
func InvigoratingGalliard():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "InvigoratingGalliard2")
func InvigoratingGalliard2():
	var partylist = get_party_targets()
	MPCost(30)
	for n in partylist:
		if n.HP != 0: n.StatMod(stat.SPD, 1.25, 2)
	CloseTurn(str(charname) + "'s Invigorating Galliad motivates the party. Speed increased!")

func WhirlingBlades():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "WhirlingBlades2")
func WhirlingBlades2():
	var damage = (stats[stat.STR] * statmods[stat.STR])*0.6
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " performs a whirling dance of blades!")
	for target in enemies:
		if target.row == row_line.FRONT and target.stats[stat.HP] != 0:
			var adjusteddamage = target.take_damage(damage, damage_type.SLASH)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("")
