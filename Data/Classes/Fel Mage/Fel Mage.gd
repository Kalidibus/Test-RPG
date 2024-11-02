extends Entity

var starting_stats = {
		"HP" = 50,
		"MP" = 175,
		"HPmax" = 50,
		"MPmax" = 175,
		"STR" = 5,
		"DEF" = 20,
		"INT" = 60,
		"FTH" = 30,
		"RES" = 50,
		"EVD" = 20,
		"SPD" = 25
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

var job_description = "The Fel Mage is destruction incarnate. \n\nMaster of all elements, and capable of raining massive damage down upon foes regardless of their resistances or position. Their ability to recover MP also makes them excellent sustainers for long journies. \n\nHowever Fel Mage's lack much in the way of defenses, and must be protected. "

func _ready():
	charname = "Fel Mage"
	MaxHP = 50
	HP = 50
	MaxMP = 175
	MP = 175
	STR = 5
	INT = 60
	DEF = 20
	SPD = 25
	HATE = 30
	row = "Back"
	enemy = false
	weapontype = "impact"

	skilllist = {
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
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("FelBolt2")
func FelBolt2(target):
	var damage = INT * statmods["INT"]
	var adjusteddamage = target.take_damage(damage, "fel") 
	MPCost(10)
	CloseTurn(str(charname) + " launches an eldritch bolt of ink black Fel at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func DeepBolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("DeepBolt2")
func DeepBolt2(target):
	var damage = INT * statmods["INT"]
	var adjusteddamage = target.take_damage(damage, "deep") 
	MPCost(10)
	CloseTurn(str(charname) + " launches a bolt of icey Deep at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func LevinBolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("LevinBolt2")
func LevinBolt2(target):
	var damage = INT * statmods["INT"]
	var adjusteddamage = target.take_damage(damage, "levin") 
	MPCost(10)
	CloseTurn(str(charname) + " launches a bolt of electric Levin at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func InfernoBolt():
	if MPCheck(10) == "fail": return
	CombatGUI.TargetList("InfernoBolt2")
func InfernoBolt2(target):
	var damage = INT * statmods["INT"]
	var adjusteddamage = target.take_damage(damage, "inferno") 
	MPCost(10)
	CloseTurn(str(charname) + " launches a bolt of molten Inferno at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func FelPact():
	CombatGUI.QueueAction(self, "FelPact2")
func FelPact2():
	take_damage(20, "true")
	MPCost(-20)
	CloseTurn(str(charname) + " exchanges blood for power. MP restored!")
	
func FelStorm():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "FelStorm2")
func FelStorm2():
	var damage = (INT * statmods["INT"])/2
	var enemies = get_enemy_targets()
	MPCost(30)
	EventHandler.BattleLog(str(charname) + " unleashes a Fel Storm!")
	for target in enemies:
		if target.HP != 0:
			var adjusteddamage = target.take_damage(damage, "fel")
			EventHandler.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")

func DeepStorm():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "DeepStorm2")
func DeepStorm2():
	var damage = (INT * statmods["INT"])/2
	var enemies = get_enemy_targets()
	MPCost(30)
	EventHandler.BattleLog(str(charname) + " unleashes a Deep Storm!")
	for target in enemies:
		if target.HP != 0:
			var adjusteddamage = target.take_damage(damage, "deep")
			EventHandler.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")

func LevinStorm():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "LevinStorm2")
func LevinStorm2():
	var damage = (INT * statmods["INT"])/2
	var enemies = get_enemy_targets()
	MPCost(30)
	EventHandler.BattleLog(str(charname) + " unleashes a Levin Storm!")
	for target in enemies:
		if target.HP != 0:
			var adjusteddamage = target.take_damage(damage, "levin")
			EventHandler.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")

func InfernoStorm():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "InfernoStorm2")
func InfernoStorm2():
	var damage = (INT * statmods["INT"])/2
	var enemies = get_enemy_targets()
	MPCost(30)
	EventHandler.BattleLog(str(charname) + " unleashes an Inferno Storm!")
	for target in enemies:
		if target.HP != 0:
			var adjusteddamage = target.take_damage(damage, "inferno")
			EventHandler.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")
