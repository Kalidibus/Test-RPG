extends Entity
class_name Ratkin

func _ready():
	charname = "Ratkin"
	MaxHP = 80
	HP = 80
	MaxMP = 5
	MP = 5
	STR = 40
	DEF = 20
	RES = 3
	SPD = 30
	row = "Back"
	enemy = true
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)

func mTurn(targetlist):
	target = DecideTarget(targetlist)
	
	var rng = RNG()
	
	AttackList(target, rng)

func AttackList(target, rng):
	if rng <= 50:
		mAttack(target)
	elif rng <= 80:
		Scratch(target)
	elif rng <= 100:
		mDefend()

func mAttack(target):
	var damage:int = STR * statmods["STR"]
	
	EventHandler.BattleLog("The " + str(charname) + " unveils a twisted dagger and stabs into " + str(target.charname) + " for " + str(damage) + " damage!")
	
	target.take_damage(damage, "pierce")

func Scratch(target):
	var damage:int = 2 * STR*statmods["STR"]
	EventHandler.BattleLog("The " + str(charname) + " salivates while raking " + str(target.charname) + " wildly with claws for " + str(damage) + " damage!!!")
	
	target.take_damage(damage, "slash")

func mDefend():
	StatMod("DEF", 1.5, 0)

	EventHandler.BattleLog("The " + str(charname) + " scampers behind nearby rubble...")
