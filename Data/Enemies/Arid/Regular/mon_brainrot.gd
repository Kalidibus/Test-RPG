extends Monster

func _ready():
	charname = "Brain Rot"
	reward_xp = Globals.RNG_range(20, 35)
	loot_table = {
		ItemDict.item.comp1: 15,
		ItemDict.item.comp2: 15,
		ItemDict.item.comp3: 15,
		ItemDict.item.comp4: 15}
	roll_count = 7
	
	enemy = true
	row = row_line.BACK
	stats = {
		stat.MAXHP: 30,
		stat.HP: 30,
		stat.MAXMP: 5,
		stat.MP: 5,
		stat.STR: 6,
		stat.DEF: 8,
		stat.DEX: 10,
		stat.FTH: 5,
		stat.INT: 5,
		stat.SPD: 8,
		stat.RES: 10,
		stat.ACC: 5,
		stat.EVD: 7,
		stat.CRIT: 10,
		stat.CRITDMG: 1.5
		}
	statres = {
		status_effects.POISON: 90,
		status_effects.STUN: 20,
		status_effects.BURN: 5,
		status_effects.BLIND: 20,
		status_effects.SEAL: 10
		}
	damageres = {
		damage_type.IMPACT: 45,
		damage_type.SLASH: 5,
		damage_type.PIERCE: 5,
		damage_type.FEL: 20,
		damage_type.INFERNAL: -35,
		damage_type.LEVIN: 20,
		damage_type.DEEP: 20,
		damage_type.ERDE: 20,
		damage_type.VIRTUOS: 20,
		damage_type.TRUE: 0
		}

func AttackList(target, rng):
	if rng <= 100:
		mAttack(target)

func mAttack(target):
	if not CheckMiss(target): return
	var dealt_damage = Damage(target, Stat(stat.DEX), damage_type.PIERCE) 
	CloseTurn("The " + str(charname) + " pierces " + str(target.charname) + " with venomous needles for " + str(dealt_damage) + " damage!")
	target.AttemptStatusAilment(status_effects.POISON, 10, 3, -30)
