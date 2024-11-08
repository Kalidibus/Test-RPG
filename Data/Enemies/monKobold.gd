extends Entity

func _ready():
	charname = "Kobold"
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
	super.Turn()
	if dead: 
		CloseTurn("")
	elif status.has("stun"):
		status.erase("stun")
		CloseTurn(charname + " misses their turn...")
	else:
		target = DecideTarget()
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
	var damage:int = stats["STR"] * statmods["STR"]
	var adjusteddamage = target.take_damage(damage, "slash")
	CloseTurn("The " + str(charname) + " draws its rusty axe and strikes " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")

func Bludgeon(target):
	var damage:int = 2 * stats["STR"] * statmods["STR"]
	var adjusteddamage = target.take_damage(damage, "impact")
	CloseTurn("The " + str(charname) + " emits a bloodcurdling shriek and bludgeons " + str(target.charname) + " fiercly for " + str(adjusteddamage) + " damage!!!")
	target.AttemptStatusAilment("stun", 0, 0)
	

func mDefend():
	StatMod("DEF", 1.5, 0)
	CloseTurn("The " + str(charname) + " hides behind a tattered shield...")
