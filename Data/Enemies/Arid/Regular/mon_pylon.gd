extends Monster

func _ready():
	
	charname = "Pylon"
	reward_xp = RNG_range(45, 75)
	loot_table = {
		"lcom001" = 25,
		"lcom002" = 25,
		"lcom003" = 25,
		"lcom004" = 25}
	roll_count = 7
	
	stats = {
		"HPMax" = 100,
		"HP" = 100,
		"MPMax" = 5,
		"MP" = 5,
		"STR" = 15,
		"DEF" = 60,
		"DEX" = 5,
		"FTH" = 5,
		"INT" = 5,
		"SPD" = 8,
		"RES" = 30,
		"EVD" = 10
		}
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
	CloseTurn("The " + charname + " slashes at " + target.charname + " for " + str(adjusteddamage) + " damage!")

func Bludgeon(target):
	var damage:int = 2 * stats["STR"] * statmods["STR"]
	var adjusteddamage = target.take_damage(damage, "impact")
	CloseTurn("The " + charname + " emits a bloodcurdling shriek and bludgeons " + target.charname + " fiercly for " + str(adjusteddamage) + " damage!!!")
	target.AttemptStatusAilment("stun", 0, 0)
	

func mDefend():
	StatMod("DEF", 1.5, 0)
	CloseTurn("The " + str(charname) + " folds it's body up defensively...")
