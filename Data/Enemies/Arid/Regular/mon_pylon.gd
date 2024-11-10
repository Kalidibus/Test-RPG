extends Monster

func _ready():
	charname = "Pylon"
	reward_xp = Globals.RNG_range(45, 75)
	loot_table = {
		"lcom001" = 55,
		"lcom002" = 15,
		"lcom003" = 15,
		"lcom004" = 15}
	roll_count = 7
	
	enemy = true
	row = "front"
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
		var rng = Globals.RNG()
		AttackList(target, rng)

func AttackList(target, rng):
	if rng <= 75: mAttack(target)
	elif rng <= 90: Bludgeon(target)
	elif rng <= 100: mDefend()

func mAttack(target):
	var damage_dealt = Damage(target, 1.1 * Stat("STR"), "slash")
	CloseTurn("The " + charname + " slashes at " + target.charname + " for " + str(damage_dealt) + " damage!")

func Bludgeon(target):
	var damage_dealt = Damage(target, 1.7 * Stat("STR"), "impact")
	CloseTurn("The " + charname + " emits a bloodcurdling shriek and bludgeons " + target.charname + " fiercly for " + str(damage_dealt) + " damage!!!")
	target.AttemptStatusAilment("stun", 0, 0, 0)
	

func mDefend():
	StatMod("DEF", 1.5, 0)
	CloseTurn("The " + str(charname) + " folds it's body up defensively...")
