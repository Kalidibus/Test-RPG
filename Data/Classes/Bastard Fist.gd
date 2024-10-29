extends Entity

var starting_stats = {
		"HP" = 100,
		"MP" = 80,
		"STR" = 70,
		"DEF" = 20,
		"INT" = 20,
		"FTH" = 30,
		"RES" = 50,
		"EVD" = 40,
		"SPD" = 40
		}

var job_description = "TBD"

func _ready():
	charname = "Bastard Fist"
	MaxHP = 100
	HP = 100
	MaxMP = 80
	MP = 80
	STR = 70
	DEF = 20
	SPD = 30
	HATE = 50
	row = "Front"
	enemy = false
	weapontype = "impact"
	
	skilllist = {
		"Crimson Rush": "Strikes an opponent with a flurry of blows. Scales with SPD and STR",
		"Scarlet Sun": "COMBO: Crimson Rush - A powerful single blow",
		"Vermillion Dance": "COMBO: Scarlet Sun - This final formation unleashes the true power of the Bastard Fists",
		"Bastard Spirit" : "Raises STR for 3 turns",
		"Lunatic Spirit" : "Greatly raises STR and SPD for 3 turns, but reduces DEF",
		"Shear Grit" : "Recover a percentage of missing health"
	}

func CrimsonRush():
	if MPCheck(15) == "fail": return
	else: CombatGUI.TargetList("CrimsonRush2")
func CrimsonRush2(target):
	var damage = (STR+SPD)/4
	combo = "CrimsonRush"
	MPCost(15)
	for number in range(3):
		var adjusteddamage = target.take_damage(damage, "impact")
		EventHandler.BattleLog(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")
		await get_tree().create_timer(0.5).timeout
	CloseTurn("")

func BastardSpirit():
	if MPCheck(15) == "fail": return
	else: CombatGUI.QueueAction(self, "BastardSpirit2")
func BastardSpirit2():
	MPCost(15)
	StatMod("STR", 1.25, 2)
	CloseTurn(str(charname) + " draws upon her Bastard Spirit. STR Increased.")

func LunaticSpirit():
	if MPCheck(20) == "fail": return
	else: CombatGUI.QueueAction(self, "LunaticSpirit2")
func LunaticSpirit2():
	MPCost(20)
	StatMod("STR", 1.5, 2)
	StatMod("SPD", 1.5, 2)
	StatMod("DEF", 0.6, 2)
	CloseTurn(str(charname) + " draws upon her Lunatic Spirit. STR and SPD Increased! DEF Decreased.")

func ScarletSun():
	if combo != "CrimsonRush":
		EventHandler.BattleLog("Combo not ready!")
		return
	if MPCheck(20) == "fail": return
	else: CombatGUI.TargetList("ScarletSun2")
func ScarletSun2(target):
	var damage = STR+SPD * 1.2
	var adjusteddamage = target.take_damage(damage, "impact")
	MPCost(20)
	combo = "ScarletSun"
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")

func VermillionDance():
	if combo != "ScarletSun":
		EventHandler.BattleLog("Combo not ready!")
		return
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "VermillionDance2")
func VermillionDance2():
	MPCost(30)
	var enemies = get_enemy_targets()
	var damage = STR+SPD * 1.3
	EventHandler.BattleLog(str(charname) + " unleashes the Vermillion Dance!")
	for target in enemies:
		if target.HP != 0:
			var adjusteddamage = target.take_damage(damage, "impact")
			EventHandler.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	combo = ""
	CloseTurn("The dance ends...")

func ShearGrit():
	if MPCheck(30) == "fail": return
	else: CombatGUI.QueueAction(self, "ShearGrit2")
func ShearGrit2():
	get_healed(MaxHP*0.5)
	MPCost(30)
	CloseTurn(str(charname) + " grits her teeth through the pain. HP recovered!")
