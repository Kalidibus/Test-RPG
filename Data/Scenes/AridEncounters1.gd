extends Node

# Change depending on zone, and what monsters should appear there. IE for Arid, have Arid monsters
# preloaded below. For Deep same etc. 
# Then in the GetEnemies function, set up at least 5 encounter combinations.
onready var enemy1 = preload("res://Enemies/monKobold.tscn")
onready var enemy2 = preload("res://Enemies/monRatkin.tscn")

onready var battlers = get_node("../Battlers")


func GetEnemies():
	var num = RandomNumberGenerator.new()
	num.randomize()
	var rng = num.randi_range(1, 5)
	
	if rng == 1:
		battlers.add_child(enemy1.instance())
	if rng == 2:
		battlers.add_child(enemy1.instance())
		battlers.add_child(enemy2.instance())
	if rng == 3:
		battlers.add_child(enemy1.instance())
		battlers.add_child(enemy1.instance())
		battlers.add_child(enemy2.instance())
	if rng == 4:
		battlers.add_child(enemy1.instance())
		battlers.add_child(enemy1.instance())
		battlers.add_child(enemy1.instance())
		battlers.add_child(enemy1.instance())
	if rng == 5:
		battlers.add_child(enemy1.instance())
		battlers.add_child(enemy2.instance())
		battlers.add_child(enemy2.instance())
		battlers.add_child(enemy1.instance())
