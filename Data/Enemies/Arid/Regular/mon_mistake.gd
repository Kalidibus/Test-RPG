extends Monster

func _ready():
	charname = "Mistake"
	reward_xp = Globals.RNG_range(45, 75)
	loot_table = {
		"lcom001" = 55,
		"lcom002" = 15,
		"lcom003" = 15,
		"lcom004" = 15}
	roll_count = 7
	
	enemy = true
	stats = {
		"HPMax" = 50,
		"HP" = 50,
		"MPMax" = 5,
		"MP" = 5,
		"STR" = 15,
		"DEF" = 30,
		"DEX" = 25,
		"FTH" = 5,
		"INT" = 5,
		"SPD" = 8,
		"RES" = 30,
		"EVD" = 10
		}
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
		var rng = Globals.RNG()
		AttackList(target, rng)

func AttackList(target, rng):
	if rng <= 100:
		mAttack(target)

func mAttack(target):
	var dealt_damage = Damage(target, Stat("DEX"), "pierce") 
	CloseTurn("The " + str(charname) + " pierces " + str(target.charname) + " with venomous tendrils for " + str(dealt_damage) + " damage!")
	target.AttemptStatusAilment("poison", 20, 3, 0)
