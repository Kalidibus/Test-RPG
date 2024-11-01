extends Entity

var starting_stats = {
		"HP" = 100,
		"MP" = 80,
		"STR" = 70,
		"DEF" = 20,
		"INT" = 20,
		"FTH" = 30,
		"RES" = 50,
		"EVD" = 20,
		"SPD" = 40
		}

var job_description = "The Samurai Vocation readies a single strike for perfect execution. \n\nBy steadying ones mind through the chaos of battle, the perfect moment to draw your sword and strike arrives. A unique vocation that rewards carefully buffing individual devastating attacks. \n\nVery low ranged utility, and if vulnerable while charging it's strike."

func _ready():
	charname = "Samurai"
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
	weapontype = "slash"
	
	skilllist = {
		"DEV hit": "Strikes an opponent with a flurry of blows. Scales with SPD and STR"
	}

func DEVhit():
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
