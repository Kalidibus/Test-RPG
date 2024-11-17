extends Entity

#PASSIVES

#STATS
var starting_stats = {
		stat.HP: 50,
		stat.MP: 175,
		stat.MAXHP: 50,
		stat.MAXMP: 175,
		stat.STR: 5,
		stat.DEX: 10,
		stat.DEF: 20,
		stat.INT: 60,
		stat.FTH: 30,
		stat.RES: 50,
		stat.EVD: 20,
		stat.ACC: 30,
		stat.SPD: 25,
		stat.CRIT: 10,
		stat.CRITDMG: 1.5
		}
var stat_scaling = {
		stat.MAXHP: "B",
		stat.MAXMP: "S",
		stat.STR: "D",
		stat.DEX: "D",
		stat.DEF: "C",
		stat.INT: "S",
		stat.FTH: "A",
		stat.RES: "A",
		stat.EVD: "B",
		stat.ACC: "B",
		stat.SPD: "B",
		stat.CRIT: "F",
		stat.CRITDMG: "F"
	}
var job_description = "The Fel Mage is destruction incarnate. \n\nMaster of all elements, and capable of raining massive damage down upon foes regardless of their resistances or position. Their ability to recover MP also makes them excellent sustainers for long journies. \n\nHowever Fel Mage's lack much in the way of defenses, and must be protected. "

func _ready():
	HATE = 30
	weapontype = damage_type.IMPACT
	
	skill_list = {
		"skillFELMAGE01" = {"skillname" = "Fel Bolt",
			"skilldesc" = "A Fel aspected attack, dealing moderate damage."},
		"skillFELMAGE02" = {"skillname" = "Deep Bolt",
			"skilldesc" = "A Deep aspected attack, dealing moderate damage."},
		"skillFELMAGE03" = {"skillname" = "Levin Bolt",
			"skilldesc" = "A Levin aspected attack, dealing moderate damage."},
		"skillFELMAGE04" = {"skillname" = "Inferno Bolt",
			"skilldesc" = "An Inferno aspected attack, dealing moderate damage."},
		"skillFELMAGE05" = {"skillname" = "Fel Storm",
			"skilldesc" = "A Fel aspected attack, dealing minor damage to all enemies."},
		"skillFELMAGE06" = {"skillname" = "Deep Storm",
			"skilldesc" = "A Deep aspected attack, dealing minor damage to all enemies."},
		"skillFELMAGE07" = {"skillname" = "Levin Storm",
			"skilldesc" = "A Levin aspected attack, dealing minor damage to all enemies."},
		"skillFELMAGE08" = {"skillname" = "Inferno Storm",
			"skilldesc" = "An Inferno aspected attack, dealing minor damage to all enemies."},
		"skillFELMAGE09" = {"skillname" = "Fel Pact",
			"skilldesc" = "Sacrfice HP for an equivilant amount of MP."}
		}

#SKILLS
func FelBolt():
	if MPCheck(10): CombatGUI.TargetList("FelBolt2")
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
