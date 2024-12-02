extends Monster

func _ready():
	charname = "Misalignment"
	reward_xp = Globals.RNG_range(10, 20)
	loot_table = {
		ItemDict.item.comp1: 55,
		ItemDict.item.comp2: 15,
		ItemDict.item.comp3: 15,
		ItemDict.item.comp4: 15}
	roll_count = Globals.ROLL_COUNT
	
	enemy = true
	row = row_line.BACK
	stats = {
		stat.MAXHP: 30,
		stat.HP: 30,
		stat.MAXMP: 5,
		stat.MP: 5,
		stat.STR: 6,
		stat.DEF: 8,
		stat.DEX: 5,
		stat.FTH: 10,
		stat.INT: 10,
		stat.SPD: 8,
		stat.RES: 10,
		stat.ACC: 5,
		stat.EVD: 7,
		stat.CRIT: 10,
		stat.CRITDMG: 1.5
		}
	statres = {
		status_effects.POISON: 10,
		status_effects.STUN: 20,
		status_effects.BURN: 20,
		status_effects.BLIND: 20,
		status_effects.SEAL: 10
		}
	damageres = {
		damage_type.IMPACT: 30,
		damage_type.SLASH: -30,
		damage_type.PIERCE: 30,
		damage_type.FEL: 5,
		damage_type.INFERNAL: 5,
		damage_type.LEVIN: 20,
		damage_type.DEEP: 20,
		damage_type.ERDE: 5,
		damage_type.VIRTUOS: -25,
		damage_type.TRUE: 0
		}

func AttackList(mtarget, rng):
	if rng <= 50: mAttack(mtarget)
	elif rng <= 90: Realign()
	elif rng <= 100: Buff()

func mAttack(mtarget):
	if not CheckMiss(mtarget): return
	var damage_dealt = Damage(mtarget, 1.2 * Stat(stat.STR), damage_type.SLASH)
	CloseTurn("The " + charname + " attacks " + mtarget.charname + " for " + str(damage_dealt) + " damage!")

func Realign():
	var total_leech = 0
	CombatGUI.BattleLog(charname + " realigns the battlefield!")

	#leeches health from party
	for n in get_party_targets():
		if not CheckMiss(n): 
			CombatGUI.BattleLog(n.charname + " evades!")
			await get_tree().create_timer(0.5).timeout
		else: 
			var damage_dealt = Damage(n, 0.8 * Stat(stat.FTH), damage_type.FEL)
			CombatGUI.BattleLog(charname + " leeches " + damage_dealt + " health from " + n.charname + "!")
			total_leech += int(damage_dealt)
			await get_tree().create_timer(0.5).timeout
	#calculates the total amount leeched, and how much to give back to enemies
	var enemy_array = get_enemy_targets()
	var amount_healed = total_leech / enemy_array.size()

	#gives it back to enemies
	for e in enemy_array:
		e.get_healed(amount_healed)
		CombatGUI.BattleLog(charname + " transfers " + str(amount_healed) + " health to " + e.charname + "!")
		await get_tree().create_timer(0.5).timeout
	CloseTurn("")
	

func Buff():
	CombatGUI.BattleLog(charname + " infuses the enemy party with vigor!")

	#gives it back to enemies
	for e in get_enemy_targets():
		if e == self: pass
		StatMod(stat.STR, 25, 3)
		StatMod(stat.DEX, 25, 3)
		StatMod(stat.DEF, 25, 3)
		CombatGUI.BattleLog(charname + " invigorates " + e.charname + "! Physical damage and defenses bolstered!")
		await get_tree().create_timer(0.5).timeout
	CloseTurn("")
