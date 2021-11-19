extends Entity
class_name Kobold

func _ready():
	charname = "Kobold"
	MaxHP = 150
	HP = 150
	MaxMP = 5
	MP = 5
	STR = 15
	DEF = 50
	SPD = 8
	RES = 20
	row = "Front"
	enemy = true

func mTurn(targetlist):
	Turn()
	target = DecideTarget(targetlist)
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
