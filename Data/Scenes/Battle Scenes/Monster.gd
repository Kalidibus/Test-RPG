extends Entity
class_name Monster

var reward_xp
var loot_table #should always add up to 100
var roll_count

func _ready():
	pass

#loot_table and roll_count are defined on individual monster scripts
func LootRolls():
	var total_chance = 0
	var count = 0
	var earned_loot = {}
	
	while roll_count > count:
		var rng = RNG()
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
