extends Monster

func _ready():
	charname = "Cutter"
	row = row_line.FRONT
	enemy = true
	
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
		CloseTurn(charname + " misses their turn...")
	else:
		target = DecideTarget()
		var rng = Globals.RNG()
		AttackList(target, rng)

func AttackList(target, rng):
	if rng <= 100:
		mAttack(target)

func mAttack(target):
	var damage:int = stats[stat.STR] * statmods[stat.STR]
	
	var adjusteddamage = target.take_damage(damage, damage_type.SLASH)
	
	CloseTurn("The " + str(charname) + " slashes " + str(target.charname) + " with sharp blades for " + str(adjusteddamage) + " damage!")
