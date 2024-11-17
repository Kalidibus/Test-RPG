extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


#add monsters here that can be spawned. Uses the enemy dictionary as a master reference, you just need the "e01" code for the monster you want. 
#adjust the RNG_range to add new spawn configurations to the list.
#The duplicate is needed because otherwise it passes along the reference to the dictionary itself instead of being a new variable
func Encounters():
	var rng = Globals.RNG_range(1, 5)
	var spawn = []
	var en = EnemyDict.enemydict
	var count = 0
	
	var mon1 = en[EnemyDict.enemy.PYLON]
	var mon2 = en[EnemyDict.enemy.BRAINROT]
	
	match rng:
		1: for i in range(2): 
			spawn.append(mon1.duplicate())
		2: for i in range(2):
			spawn.append(mon2.duplicate())
		3: 
			spawn.append(mon1.duplicate())
			spawn.append(mon2.duplicate())
		4:
			spawn.append(mon2.duplicate())
			spawn.append(mon1.duplicate())
			spawn.append(mon2.duplicate())
		5:
			spawn.append(mon1.duplicate())
			spawn.append(mon2.duplicate())
			spawn.append(mon1.duplicate())
	return spawn
