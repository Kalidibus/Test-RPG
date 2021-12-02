extends Entity

func _ready():
	charname = "Ratkin"
	MaxHP = 180
	HP = 180
	MaxMP = 5
	MP = 5
	STR = 40
	DEF = 30
	RES = 20
	SPD = 30
	row = "Back"
	enemy = true
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	statres = {
		"poison": 10,
		"stun": 5,
		"burn": 20,
		"blind": 80,
		"seal": 10
	}

	damageres = {
		"impact": 30,
		"slash": 5,
		"pierce": 10,
		"fel": 40,
		"inferno": 5,
		"levin": 10,
		"deep": -30,
		"erde": 50,
		"virtuos": 5,
		"true": 0
	}
func Turn():
	.Turn()
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
	if rng <= 50:
		mAttack(target)
	elif rng <= 80:
		Scratch(target)
	elif rng <= 100:
		mDefend()

func mAttack(target):
	var damage:int = STR * statmods["STR"]
	var adjusteddamage = target.take_damage(damage, "pierce")
	CloseTurn("The " + str(charname) + " unveils a twisted dagger and stabs into " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")

func Scratch(target):
	var damage:int = 2 * STR*statmods["STR"]
	var adjusteddamage = target.take_damage(damage, "slash")
	CloseTurn("The " + str(charname) + " salivates while raking " + str(target.charname) + " wildly with claws for " + str(damage) + " damage!!!")

func mDefend():
	StatMod("DEF", 1.5, 0)
	CloseTurn("The " + str(charname) + " scampers behind nearby rubble...")
