extends Entity

enum skillid {Illu00, Illu01, Illu02, Illu03, Illu04, Illu05, Illu06, Illu07, Illu08, Illu09, Illu10, Illu11, Illu12, Illu13, Illu14, Illu15, Illu16, Illu17, Illu18, Illu19, Illu20 }

#Passives
var MISTBORNE_active = false
var MISTBORNE_active_count = 0
var SHAPESINTHEFOG = true
var DECEIT: int = 0

var starting_stats = {
		stat.HP: 80,
		stat.MAXHP: 80,
		stat.MP: 120,
		stat.MAXMP: 120,
		stat.STR: 70,
		stat.DEX: 70,
		stat.DEF: 50,
		stat.INT: 25,
		stat.FTH: 60,
		stat.RES: 50,
		stat.EVD: 120,
		stat.ACC: 70,
		stat.SPD: 60,
		stat.CRIT: 10,
		stat.CRITDMG: 1.5
		}
var stat_scaling = {
		stat.HP: stat_scale.A,
		stat.MP: stat_scale.B,
		stat.MAXHP: stat_scale.A,
		stat.MAXMP: stat_scale.B,
		stat.STR: stat_scale.D,
		stat.DEX: stat_scale.D,
		stat.DEF: stat_scale.B,
		stat.INT: stat_scale.A,
		stat.FTH: stat_scale.B,
		stat.RES: stat_scale.B,
		stat.EVD: stat_scale.S,
		stat.ACC: stat_scale.B,
		stat.SPD: stat_scale.S,
		stat.CRIT: stat_scale.F,
		stat.CRITDMG: stat_scale.F,
		stat.HATE: stat_scale.S
}
var job_description = "The Illusionist Vocation channels the art of silver mist to protect the party with high Evasion. \n\nFocusing on a variety of ways to confuse enemies and help the party avoid fatal blows, the Illusionist is an unconventional, but highly effective tank in the right encounter. Evading attacks grants the Illusionist a resource called [b]Deceit[/b] which allows for the execution of potent Confusing abilities. \n\nEnemies that are highly resistant to blind or confusion may have an easier time finding their mark against an Illusionist."

func _ready():
	charname = "Illusionist"
	HATE = 100
	enemy = false
	weapontype = damage_type.SLASH
	
	skill_list = {
		skillid.Illu01: {skill.name: "Cold Mist",
			skill.desc: "A shimmering shroud of mist engulfs the battlefield, sharply raising Party Evasion.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Illu02: {skill.name: "False Form",
			skill.desc: "False eyes on the wings of the Illusionist unnerve the enemy, increasing own Evasion and entering the Mistborne state.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Illu03: {skill.name: "Undine Aura",
			skill.desc: "Enemies become wary of the shifting shapes in the mist. Reduces enemy Crit Rate substantially. If Mistborne is active, also reduce enemy ACC.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Illu04: {skill.name: "Treacherous Strike",
			skill.desc: "A sinister strike into an enemies weak point. Scales off of accumulated DECEIT and has a high chance to crit.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Illu05: {skill.name: "Ocular Flash",
			skill.desc: "Emits a focused flash of light from eyespots. High chance of inflicting blind on one enemy.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0},
		skillid.Illu06: {skill.name: "Broad Flash",
			skill.desc: "Emits a broad flash of light from eyespots. Moderate chance of inflicting blind on enemy party.",
			skill.max_level: 5,
			skill.parent_unlock_level: 1,
			skill.current_level: 0}
			}

func ConnectSignals():
	SignalBus.dodged.connect(_on_dodge)
func Turn():
	#Check Mistborne status and decriment if needed
	if MISTBORNE_active == true: 
		MISTBORNE_active_count -= 1
		if MISTBORNE_active_count == 0: 
			MISTBORNE_active = false
			CombatGUI.BattleLog("Mistborne is no longer active")
	super.Turn()

func _on_dodge(defender, attacker):
	if defender == self: 
		DECEIT += 1
		CombatGUI.BattleLog(charname + " accumulates Deceit! Current Deceit is " + str(DECEIT))
		if SHAPESINTHEFOG == true:
			if CheckMiss(attacker) == true:
				var damage = Damage(attacker, Stat(stat.INT), damage_type.DEEP)
				CombatGUI.BattleLog(charname + " counter-attacks " + attacker.charname + " for " + str(damage) + "!" )
	else: pass #can add a check here to see if passive is enabled to allow countering for whole party.

func FalseForm():
	if MPCheck(10) ==false: return
	else: CombatGUI.QueueAction(self, "FalseForm2")
func FalseForm2():
	MPCost(10)
	StatMod(stat.EVD, 1.5, 4)
	MISTBORNE_active = true
	MISTBORNE_active_count = 4
	CloseTurn(str(charname) + " enters the Mistborne state! Evasion increased!")

func ColdMist():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "ColdMist2")
func ColdMist2():
	var partylist = get_party_targets()
	MPCost(30)
	for n in partylist:
		if n.stats[stat.HP] != 0: n.StatMod(stat.EVD, 1.6, 1)
	CloseTurn(str(charname) + "'s Cold Mist billows across the battlefield. Party Evasion increased!")
  
func UndineAura():
	if MPCheck(30) == false: return
	else: CombatGUI.QueueAction(self, "UndineAura2")
func UndineAura2():
	var enemylist = get_enemy_targets()
	MPCost(30)
	for n in enemylist:
		n.StatMod(stat.CRIT, 0.4, 3)
		if MISTBORNE_active == true: n.StatMod(stat.ACC, 0.7, 3)
	if MISTBORNE_active == true: CloseTurn(str(charname) + "'s exudes an Undine Aura. Enemy Crit and Accuracy decreased!")
	else: CloseTurn(str(charname) + "'s exudes an Undine Aura. Enemy Crit decreased!")

func TreacherousStrike():
	if MPCheck(20) == false or DECEIT == 0: return
	else: CombatGUI.TargetList("TreacherousStrike2")
func TreacherousStrike2(target):
	StatMod(stat.CRIT, 1.5, 0)
	var adjusteddamage = Damage(target, stats[stat.INT] * DECEIT, damage_type.DEEP)
	MPCost(20)
	DECEIT = 0
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")

func OcularFlash():
	if MPCheck(10) == false: return
	else: CombatGUI.TargetList("OcularFlash2")
func OcularFlash2(target):
	MPCost(10)
	CombatGUI.BattleLog(charname + " attempts to blind " + target.charname)
	target.AttemptStatusAilment(status_effects.BLIND, 0, 3, 25)
	CloseTurn("")

func BroadFlash():
	if MPCheck(20) == false: return
	else: CombatGUI.QueueAction(self, "BroadFlash2")
func BroadFlash2():
	MPCost(20)
	CombatGUI.BattleLog(charname + " attempts to blind the enemy party!")
	for n in get_enemy_targets():
		n.AttemptStatusAilment(status_effects.BLIND, 0, 3, 10)
	CloseTurn("")
