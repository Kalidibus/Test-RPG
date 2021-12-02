extends Entity
class_name Raklak

func _ready():
	charname = "Raklak"
	MaxHP = 180
	HP = 180
	MaxMP = 5
	MP = 5
	STR = 40
	DEF = 30
	SPD = 18
	RES = 20
	row = "Front"
	enemy = true
	
	statres = {
		"poison": 90,
		"stun": 20,
		"burn": 5,
		"blind": 20,
		"seal": 10
	}

	damageres = {
		"impact": 5,
		"slash": 20,
		"pierce": 20,
		"fel": 20,
		"inferno": -25,
		"levin": 20,
		"deep": 20,
		"erde": 20,
		"virtuos": 20,
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
	if rng <= 100:
		mAttack(target)

func mAttack(target):
	var damage:int = STR * statmods["STR"]
	
	var adjusteddamage = target.take_damage(damage, "pierce")
	
	CloseTurn("The " + str(charname) + " bites " + str(target.charname) + " with venomous fangs for " + str(adjusteddamage) + " damage!")
	target.AttemptStatusAilment("poison", 20, 3)
