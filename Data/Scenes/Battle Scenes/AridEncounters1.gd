extends Node

# Change depending on zone, and what monsters should appear there. IE for Arid, have Arid monsters
# preloaded below. For Deep same etc. 
# Then in the GetEnemies function, set up at least 5 encounter combinations.
@onready var enemy1 = preload("res://Enemies/monKobold.tscn")
@onready var enemy2 = preload("res://Enemies/monRatkin.tscn")
@onready var enemy3 = preload("res://Enemies/monRaklak.tscn")

@onready var battlers = get_node("../Enemies")


func GetEnemies():
	
	var num = RandomNumberGenerator.new()
	num.randomize()
	var rng = num.randi_range(1, 6)
	
	match rng:
		1:
			battlers.add_child(enemy1.instantiate())
		2:
			battlers.add_child(enemy1.instantiate())
			battlers.add_child(enemy2.instantiate())
		3:
			battlers.add_child(enemy1.instantiate())
			battlers.add_child(enemy1.instantiate())
			battlers.add_child(enemy2.instantiate())
		4:
			battlers.add_child(enemy1.instantiate())
			battlers.add_child(enemy1.instantiate())
			battlers.add_child(enemy1.instantiate())
			battlers.add_child(enemy1.instantiate())
		5:
			battlers.add_child(enemy1.instantiate())
			battlers.add_child(enemy2.instantiate())
			battlers.add_child(enemy2.instantiate())
			battlers.add_child(enemy3.instantiate())
		6: 
			battlers.add_child(enemy3.instantiate())
			battlers.add_child(enemy3.instantiate())
