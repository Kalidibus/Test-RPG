extends Node

var player_file_path = "user://player_save.json"

func save_file():
	var file = FileAccess.open(player_file_path, FileAccess.WRITE)
	file.store_var(Globals.inventory)
	file.store_var(Globals.roster)
	file.store_var(Globals.party)
	Globals.system_message("File Saved!")


func load_file():
	var file = FileAccess.open(player_file_path, FileAccess.READ)
	if not file:
		Globals.system_message("No Save Data to Load")
		return
	Globals.inventory = file.get_var(0)
	Globals.roster = file.get_var(1)
	Globals.party = file.get_var(2)
	Globals.system_message("File Loaded!")
