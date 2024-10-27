extends Node

var player_file_path = "user://player_save.json"

func save_file():
	var file = FileAccess.open(player_file_path, FileAccess.WRITE)
	file.store_var(Globals.inventory)
	file.store_var(Globals.roster)
	file.store_var(Globals.party)


func load_file():
	var file = FileAccess.open(player_file_path, FileAccess.READ)
	Globals.inventory = file.get_var(0)
	Globals.roster = file.get_var(1)
	Globals.party = file.get_var(2)
