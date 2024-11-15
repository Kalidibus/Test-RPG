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
	row = row_line.FRONT
	stats = {
		stat.MAXHP: 100,
		stat.HP: 100,
		stat.MAXMP: 5,
		stat.MP: 5,
		stat.STR: 15,
		stat.DEF: 60,
		stat.DEX: 5,
		stat.FTH: 5,
		stat.INT: 5,
		stat.SPD: 8,
		stat.RES: 30,
		stat.ACC: 20,
		stat.EVD: 10
		}
	statres = {
		status_effects.POISON: 10,
		status_effects.STUN: 50,
		status_effects.BURN: 20,
		status_effects.BLIND: 80,
		status_effects.SEAL: 10
		}
	damageres = {
		damage_type.IMPACT: 20,
		damage_type.SLASH: 5,
		damage_type.PIERCE: 20,
		damage_type.FEL: 10,
		damage_type.INFERNAL: 10,
		damage_type.LEVIN: -20,
		damage_type.DEEP: 10,
		damage_type.ERDE: 50,
		damage_type.VIRTUOS: -5,
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
	if rng <= 75: mAttack(target)
	elif rng <= 90: Bludgeon(target)
	elif rng <= 100: mDefend()

func mAttack(target):
	if not CheckMiss(target): return
	var damage_dealt = Damage(target, 1.1 * Stat(stat.STR), damage_type.SLASH)
	CloseTurn("The " + charname + " slashes at " + target.charname + " for " + str(damage_dealt) + " damage!")

func Bludgeon(target):
	if not CheckMiss(target): return
	var damage_dealt = Damage(target, 1.7 * Stat(stat.STR), damage_type.IMPACT)
	CloseTurn("The " + charname + " emits a bloodcurdling shriek and bludgeons " + target.charname + " fiercly for " + str(damage_dealt) + " damage!!!")
	target.AttemptStatusAilment(status_effects.STUN, 0, 0, 0)
	

func mDefend():
	StatMod(stat.DEF, 1.5, 0)
	CloseTurn("The " + str(charname) + " folds it's body up defensively...")
