extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#add monsters here that can be spawned. Uses the enemy dictionary as a master reference, you just need the "e01" code for the monster you want. 
#adjust the RNG_range to add new spawn configurations to the list.
func Encounters():
	var rng = Globals.RNG_range(1, 5)
	var spawn = []
	var en = EnemyDict.enemydict
	
	var mon1 = {"e01" = en["e01"]}
	var mon2 = {"e02" = en["e02"]}
	
	match rng:
		1: for i in range(2): spawn.append(mon1) 
		2: for i in range(2): spawn.append(mon2) 
		3: 
			spawn.append(mon1) 
			spawn.append(mon2)
		4:
			spawn.append(mon2)
			spawn.append(mon1)
			spawn.append(mon2)
		5:
			spawn.append(mon1)
			spawn.append(mon2)
			spawn.append(mon1)
	return spawn
