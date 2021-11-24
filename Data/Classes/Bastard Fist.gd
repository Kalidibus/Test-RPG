extends Entity

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
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
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
	var adjusteddamage = target.take_damage(damage, "impact")
	target.take_damage(damage, "impact")
	target.take_damage(damage, "impact")
	EventHandler.BattleLog(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")	
	EventHandler.BattleLog(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")

func BastardSpirit():
	if MPCheck(15) == "fail": return
	MPCost(15)
	StatMod("STR", 1.25, 2)
	CloseTurn(str(charname) + " draws upon her Bastard Spirit. STR Increased.")

func LunaticSpirit():
	if MPCheck(20) == "fail": return
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
	MPCost(30)
	var enemies = get_tree().get_nodes_in_group("enemies")
	var damage = STR+SPD * 1.3
	EventHandler.BattleLog(str(charname) + " unleashes the Vermillion Dance!")
	for target in enemies:
		var adjusteddamage = target.take_damage(damage, "impact")
		EventHandler.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
	combo = ""
	CloseTurn("The dance ends...")

func ShearGrit():
	if MPCheck(30) == "fail": return
	get_healed(MaxHP*0.5)
	MPCost(30)
	CloseTurn(str(charname) + " grits her teeth through the pain. HP recovered!")
