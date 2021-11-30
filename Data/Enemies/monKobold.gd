extends Entity

func _ready():
	charname = "Kobold"
	MaxHP = 300
	HP = 300
	MaxMP = 5
	MP = 5
	STR = 15
	DEF = 60
	SPD = 8
	RES = 30
	row = "Front"
	enemy = true

	statres = {
		"poison": 10,
		"stun": 50,
		"burn": 20,
		"blind": 80,
		"seal": 10
	}

	damageres = {
		"impact": 20,
		"slash": 5,
		"pierce": 20,
		"fel": 10,
		"inferno": 10,
		"levin": -20,
		"deep": 10,
		"erde": 50,
		"virtuos": -5,
		"true": 0
	}

func Turn():
	.Turn()
	target = DecideTarget(enemytargetlist)
	var rng = RNG()
	AttackList(target, rng)

func AttackList(target, rng):
	if rng <= 75:
		mAttack(target)
	elif rng <= 90:
		Bludgeon(target)
	elif rng <= 100:
		mDefend()

func mAttack(target):
	var damage:int = STR * statmods["STR"]
	EventHandler.BattleLog("The " + str(charname) + " draws its rusty axe and strikes " + str(target.charname) + " for " + str(damage) + " damage!")
	target.take_damage(damage, "slash")

func Bludgeon(target):
	var damage:int = 2 * STR * statmods["STR"]
	EventHandler.BattleLog("The " + str(charname) + " emits a bloodcurdling shriek and bludgeons " + str(target.charname) + " fiercly for " + str(damage) + " damage!!!")
	target.take_damage(damage, "impact")
	target.AttemptStatusAilment("stun", 0, 0)

func mDefend():
	StatMod("DEF", 1.5, 0)
	EventHandler.BattleLog("The " + str(charname) + " hides behind a tattered shield...")
