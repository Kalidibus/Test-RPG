extends Monster

func _ready():
	charname = "Brain Rot"
	reward_xp = Globals.RNG_range(45, 75)
	loot_table = {
		"lcom001" = 55,
		"lcom002" = 15,
		"lcom003" = 15,
		"lcom004" = 15}
	roll_count = 7
	
	enemy = true
	row = "back"
	stats = {
		stat.MAXHP: 50,
		stat.HP: 50,
		stat.MAXMP: 5,
		stat.MP: 5,
		stat.STR: 15,
		stat.DEF: 30,
		stat.DEX: 25,
		stat.FTH: 5,
		stat.INT: 5,
		stat.SPD: 8,
		stat.RES: 30,
		stat.EVD: 10
		}
	statres = {
		status_effects.POISON: 90,
		status_effects.STUN: 20,
		status_effects.BURN: 5,
		status_effects.BLIND: 20,
		status_effects.SEAL: 10
		}
	damageres = {
		damage_type.IMPACT: 5,
		damage_type.SLASH: 20,
		damage_type.PIERCE: 20,
		damage_type.FEL: 20,
		damage_type.INFERNAL: -25,
		damage_type.LEVIN: 20,
		damage_type.DEEP: 20,
		damage_type.ERDE: 20,
		damage_type.VIRTUOS: 20,
		damage_type.TRUE: 0
		}

func Turn():
	super.Turn()
	if dead: 
		CloseTurn("")
	elif status.has(status_effects.STUN):
		status.erase(status_effects.STUN)
		CloseTurn("The " + charname + " misses their turn...")
	else:
		target = DecideTarget()
		var rng = Globals.RNG()
		AttackList(target, rng)

func AttackList(target, rng):
	if rng <= 100:
		mAttack(target)

func mAttack(target):
	var dealt_damage = Damage(target, Stat(stat.DEX), damage_type.PIERCE) 
	CloseTurn("The " + str(charname) + " pierces " + str(target.charname) + " with venomous needles for " + str(dealt_damage) + " damage!")
	target.AttemptStatusAilment(status_effects.POISON, 20, 3, 0)
