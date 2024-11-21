extends Entity

enum skillid {FelM00, FelM01, FelM02, FelM03, FelM04, FelM05, FelM06, FelM07, FelM08, FelM09, FelM10, FelM11, FelM12, FelM13, FelM14, FelM15, FelM16, FelM17, FelM18, FelM19, FelM20}

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
		stat.HP: stat_scale.B,
		stat.MP: stat_scale.S,
		stat.MAXHP: stat_scale.B,
		stat.MAXMP: stat_scale.S,
		stat.STR: stat_scale.D,
		stat.DEX: stat_scale.D,
		stat.DEF: stat_scale.C,
		stat.INT: stat_scale.S,
		stat.FTH: stat_scale.A,
		stat.RES: stat_scale.A,
		stat.EVD: stat_scale.B,
		stat.ACC: stat_scale.B,
		stat.SPD: stat_scale.B,
		stat.CRIT: stat_scale.F,
		stat.CRITDMG: stat_scale.F,
		stat.HATE: stat_scale.C
	}
var job_description = "The Fel Mage is destruction incarnate. \n\nMaster of all elements, and capable of raining massive damage down upon foes regardless of their resistances or position. Their ability to recover MP also makes them excellent sustainers for long journies. \n\nHowever Fel Mage's lack much in the way of defenses, and must be protected. "

func _ready():
	HATE = 30
	weapontype = damage_type.IMPACT
	
	skill_list = {
		skillid.FelM01: {skill.name: "Fel Bolt",
			skill.desc: "A Fel aspected attack, dealing moderate damage.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.FelM02: {skill.name: "Deep Bolt",
			skill.desc: "A Deep aspected attack, dealing moderate damage.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.FelM03: {skill.name: "Levin Bolt",
			skill.desc: "A Levin aspected attack, dealing moderate damage.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.FelM04: {skill.name: "Inferno Bolt",
			skill.desc: "An Inferno aspected attack, dealing moderate damage.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.FelM05: {skill.name: "Fel Storm",
			skill.desc: "A Fel aspected attack, dealing minor damage to all enemies.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.FelM06: {skill.name: "Deep Storm",
			skill.desc: "A Deep aspected attack, dealing minor damage to all enemies.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.FelM07: {skill.name: "Levin Storm",
			skill.desc: "A Levin aspected attack, dealing minor damage to all enemies.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.FelM08: {skill.name: "Inferno Storm",
			skill.desc: "An Inferno aspected attack, dealing minor damage to all enemies.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.FelM09: {skill.name: "Fel Pact",
			skill.desc: "Sacrfice HP for an equivilant amount of MP.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0}
		}
#SKILLS
func FelBolt():
	if MPCheck(10): CombatGUI.TargetList("FelBolt2")
func FelBolt2(target):
	var adjusteddamage = Damage(target, stat.INT, damage_type.FEL)
	MPCost(10)
	CloseTurn(str(charname) + " launches an eldritch bolt of ink black Fel at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func DeepBolt():
	if MPCheck(10) == false: return
	CombatGUI.TargetList("DeepBolt2")
func DeepBolt2(target):
	var adjusteddamage = Damage(target, stat.INT, damage_type.DEEP)
	MPCost(10)
	CloseTurn(str(charname) + " launches a bolt of icey Deep at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func LevinBolt():
	if MPCheck(10) == false: return
	CombatGUI.TargetList("LevinBolt2")
func LevinBolt2(target):
	var adjusteddamage = Damage(target, stat.INT, damage_type.LEVIN)
	MPCost(10)
	CloseTurn(str(charname) + " launches a bolt of electric Levin at " + str(target.charname) + ", hitting it for " + str(adjusteddamage) + " damage!")

func InfernoBolt():
	if MPCheck(10) == false: return
	CombatGUI.TargetList("InfernoBolt2")
func InfernoBolt2(target):
	var adjusteddamage = Damage(target, stat.INT, damage_type.INFERNAL)
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
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " unleashes a Fel Storm!")
	for target in enemies:
		if target.stats[stat.HP] != 0:
			var adjusteddamage = Damage(target, stat.INT / 2, damage_type.FEL)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")

func DeepStorm():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "DeepStorm2")
func DeepStorm2():
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " unleashes a Deep Storm!")
	for target in enemies:
		if target.stats[stat.HP] != 0:
			var adjusteddamage = Damage(target, stat.INT / 2, damage_type.DEEP)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")

func LevinStorm():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "LevinStorm2")
func LevinStorm2():
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " unleashes a Levin Storm!")
	for target in enemies:
		if target.stats[stat.HP] != 0:
			var adjusteddamage = Damage(target, stat.INT / 2, damage_type.LEVIN)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")

func InfernoStorm():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "InfernoStorm2")
func InfernoStorm2():
	var enemies = get_enemy_targets()
	MPCost(30)
	CombatGUI.BattleLog(str(charname) + " unleashes an Inferno Storm!")
	for target in enemies:
		if target.stats[stat.HP] != 0:
			var adjusteddamage = Damage(target, stat.INT / 2, damage_type.INFERNAL)
			CombatGUI.BattleLog(str(target.charname) + " is hit for " + str(adjusteddamage) + " damage!")
			await get_tree().create_timer(0.5).timeout
	CloseTurn("The storm abates...")
