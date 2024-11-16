extends Entity

var starting_stats = {
		stat.HP: 100,
		stat.MP: 80,
		stat.STR: 70,
		stat.DEF: 20,
		stat.INT: 20,
		stat.FTH: 30,
		stat.RES: 50,
		stat.EVD: 20,
		stat.ACC: 40,
		stat.SPD: 40,
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

var job_description = "The Samurai Vocation readies a single strike for perfect execution. \n\nBy steadying ones mind through the chaos of battle, the perfect moment to draw your sword and strike arrives. A unique vocation that rewards carefully buffing individual devastating attacks. \n\nVery low ranged utility, and if vulnerable while charging it's strike."

func _ready():
	charname = "Samurai"
	HATE = 50
	enemy = false
	weapontype = damage_type.SLASH
	
	skill_list = {
		"DEV hit": "Strikes an opponent with a flurry of blows. Scales with SPD and STR"
	}

func DEVhit():
	if MPCheck(15) == false: return
	else: CombatGUI.TargetList("CrimsonRush2")
func CrimsonRush2(target):
	var damage = (stats[stat.STR] + stats[stat.SPD])/4
	combo = "CrimsonRush"
	MPCost(15)
	for number in range(3):
		var adjusteddamage = target.take_damage(damage, damage_type.IMPACT)
		CombatGUI.BattleLog(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")
		await get_tree().create_timer(0.5).timeout
	CloseTurn("")
