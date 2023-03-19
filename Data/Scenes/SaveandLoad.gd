extends Node

var player_file_path = "user://player_save.json"

var inventory = {
	"Bomb" : 3,
	"Potion" : 2
}

var party = {}

func save_file():
	var file = FileAccess.open(player_file_path, FileAccess.WRITE)
	file.store_var(inventory)
	print(inventory)

func load_file():
	var file = FileAccess.open(player_file_path, FileAccess.READ)
	inventory = file.get_var(0)
	print(inventory)

#for testing only
#func increment_bombs():
#	inventory["Bomb"] = inventory["Bomb"] +1
#	print(inventory)
	
