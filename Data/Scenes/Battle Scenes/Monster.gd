extends Entity
class_name Monster

var reward_xp
var loot_table #should always add up to 100
var roll_count

func _ready():
	pass

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

func AttackList(target,rng):
	pass #handled on individual monster files.

#loot_table and roll_count are defined on individual monster scripts
func LootRolls():
	var total_chance = 0
	var count = 0
	var earned_loot = {}
	
	while roll_count > count:
		var rng = Globals.RNG()
		#Determine which item was selected
		var cumulative_chance = 0
		for n in loot_table:
			cumulative_chance += loot_table[n]
			if rng < cumulative_chance:
				if earned_loot.has(n): earned_loot[n] += 1
				else: earned_loot[n] = 1
				break
		count += 1
	return earned_loot

func DecideTarget():
	print(stats[stat.CRIT])
	print(stats[stat.CRITDMG])
	#checks for the status_effects.MARKED status, which is used by provoke abilities, or can also be used by enemies to designate one target to destroy
	#markedamount is the variable on the target which shows the chance of skipping the normal aggro calculation. 
	var rng = Globals.RNG()
	var targetlist = []
		
	for n in get_party_targets():
		if n.stats[stat.HP] != 0:
			targetlist.append(n)
	
	for n in targetlist:
		if n.status.has(status_effects.MARKED):
			if rng <= n.markedamount: return n
	
	var total_hate = 0
	
	for n in targetlist:
		total_hate += n.HATE
		n.ref_hate = total_hate
		
	rng = randf_range(0, total_hate)
	
	for n in targetlist:
		if (n.ref_hate > rng) and n.stats[stat.HP] != 0:
			return n
