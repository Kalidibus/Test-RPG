extends Entity

var starting_stats = {
		stat.HP: 80,
		stat.MP: 125,
		stat.STR: 80,
		stat.DEF: 50,
		stat.INT: 60,
		stat.FTH: 30,
		stat.RES: 50,
		stat.EVD: 20,
		stat.ACC: 40,
		stat.SPD: 25,
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

var job_description = "The War Mage is a frontline caster with explosive capabilities. \n\nSpecializing in close-range Levin and Infernal damage, they are monsters against groups of enemies that fight in the front-line. Hitting enemies with Infernal or Levin damage also accumulates a resource called [b]Overheat[/b] which can be used to fuel explosive attacks that hit the whole enemy party. \n\nThier capabilities against single enemies, or ranged enemies can be found lacking."

func _ready():
	charname = "War Mage"
	HATE = 30
	enemy = false
	weapontype = damage_type.IMPACT

	skill_list = {
		"Fel Bolt" : "A Fel aspected attack, dealing moderate damage.",
		"Deep Bolt" : "A Deep aspected attack, dealing moderate damage.",
		"Levin Bolt" : "A Levin aspected attack, dealing moderate damage.",
		"Inferno Bolt" : "An Inferno aspected attack, dealing moderate damage.",
		"Fel Storm" : "A Fel aspected attack, dealing minor damage to all enemies.",
		"Deep Storm" : "A Deep aspected attack, dealing minor damage to all enemies.",
		"Levin Storm" : "A Levin aspected attack, dealing minor damage to all enemies.",
		"Inferno Storm" : "An Inferno aspected attack, dealing minor damage to all enemies.",
		"Fel Pact" : "Sacrfice HP for an equivilant amount of MP."
	}

func FelBolt():
	if MPCheck(10) == false: return
	CombatGUI.TargetList("FelBolt2")
func FelBolt2(target):
	var damage = stats[stat.INT] * statmods[stat.INT]
	var adjusteddamage = target.take_damage(damage, damage_type.FEL) 
	MPCost(10)
	CloseTurn(str(charname) + " launches an eldritch bolt of ink black Fel at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func DeepBolt():
	if MPCheck(10) == false: return
	CombatGUI.TargetList("DeepBolt2")
func DeepBolt2(target):
	var damage = stats[stat.INT] * statmods[stat.INT]
	var adjusteddamage = target.take_damage(damage, damage_type.DEEP) 
	MPCost(10)
	CloseTurn(str(charname) + " launches a bolt of icey Deep at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func LevinBolt():
	if MPCheck(10) == false: return
	CombatGUI.TargetList("LevinBolt2")
func LevinBolt2(target):
	var damage = stats[stat.INT] * statmods[stat.INT]
	var adjusteddamage = target.take_damage(damage, damage_type.LEVIN) 
	MPCost(10)
	CloseTurn(str(charname) + " launches a bolt of electric Levin at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func InfernoBolt():
	if MPCheck(10) == false: return
	CombatGUI.TargetList("InfernoBolt2")
func InfernoBolt2(target):
	var damage = stats[stat.INT] * statmods[stat.INT]
	var adjusteddamage = target.take_damage(damage, damage_type.INFERNAL) 
	MPCost(10)
	CloseTurn(str(charname) + " launches a bolt of molten Inferno at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func FelPact():
	CombatGUI.QueueAction(self, "FelPact2")
func FelPact2():
	take_damage(20, damage_type.TRUE)
	MPCost(-20)
	CloseTurn(str(charname) + " exchanges blood for power. MP restored!")
	
func FelStorm():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "FelStorm2")
func FelStorm2():
	var damage = (stats[stat.INT] * statmods[stat.INT])/2
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " unleashes a Fel Storm!")
	for target in enemies:
		if target.stats[stat.HP] != 0:
			var adjusteddamage = target.take_damage(damage, damage_type.FEL)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")

func DeepStorm():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "DeepStorm2")
func DeepStorm2():
	var damage = (stats[stat.INT] * statmods[stat.INT])/2
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " unleashes a Deep Storm!")
	for target in enemies:
		if target.stats[stat.HP] != 0:
			var adjusteddamage = target.take_damage(damage, damage_type.DEEP)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")

func LevinStorm():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "LevinStorm2")
func LevinStorm2():
	var damage = (stats[stat.INT] * statmods[stat.INT])/2
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " unleashes a Levin Storm!")
	for target in enemies:
		if target.stats[stat.HP] != 0:
			var adjusteddamage = target.take_damage(damage, damage_type.LEVIN)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")

func InfernoStorm():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "InfernoStorm2")
func InfernoStorm2():
	var damage = (stats[stat.INT] * statmods[stat.INT])/2
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " unleashes an Inferno Storm!")
	for target in enemies:
		if target.stats[stat.HP] != 0:
			var adjusteddamage = target.take_damage(damage, damage_type.INFERNAL)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")
