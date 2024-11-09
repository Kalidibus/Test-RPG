extends Entity
class_name Raklak

func _ready():
	charname = "Raklak"
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
	if rng <= 100:
		mAttack(target)

func mAttack(target):
	var damage:int = stats["STR"] * statmods["STR"]
	
	var adjusteddamage = target.take_damage(damage, "pierce")
	
	CloseTurn("The " + str(charname) + " bites " + str(target.charname) + " with venomous fangs for " + str(adjusteddamage) + " damage!")
	target.AttemptStatusAilment("poison", 20, 3)
