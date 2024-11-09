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

var job_description = "The Samurai Vocation readies a single strike for perfect execution. \n\nBy steadying ones mind through the chaos of battle, the perfect moment to draw your sword and strike arrives. A unique vocation that rewards carefully buffing individual devastating attacks. \n\nVery low ranged utility, and if vulnerable while charging it's strike."

func _ready():
	charname = "Samurai"
	HATE = 50
	enemy = false
	weapontype = "slash"
	
	skill_list = {
		"DEV hit": "Strikes an opponent with a flurry of blows. Scales with SPD and STR"
	}

func DEVhit():
	if MPCheck(15) == "fail": return
	else: CombatGUI.TargetList("CrimsonRush2")
func CrimsonRush2(target):
	var damage = (stats["STR"] + stats["SPD"])/4
	combo = "CrimsonRush"
	MPCost(15)
	for number in range(3):
		var adjusteddamage = target.take_damage(damage, "impact")
		CombatGUI.BattleLog(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")
		await get_tree().create_timer(0.5).timeout
	CloseTurn("")
