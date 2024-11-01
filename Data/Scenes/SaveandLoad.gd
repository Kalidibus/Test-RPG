extends Node

var player_file_path = "user://player_save.json"

func ask_save():
	if await Globals.system_message_choice("Do you wish to save your game?", "Yes", "No") == "left":
		save_file()
		print("saved")

func save_file():
	var file = FileAccess.open(player_file_path, FileAccess.WRITE)
	file.store_var(PlayerData.inventory)
	file.store_var(PlayerData.roster)
	file.store_var(Globals.party)
	file.store_var(PlayerData.unlocked_classes)
	Globals.system_message("File Saved!")


func load_file():
	var file = FileAccess.open(player_file_path, FileAccess.READ)
	if not file:
		Globals.system_message("No Save Data to Load")
		return
	PlayerData.inventory = file.get_var(0)
	PlayerData.roster = file.get_var(1)
	Globals.party = file.get_var(2)
	PlayerData.unlocked_classes = file.get_var(3)
	Globals.system_message("File Loaded!")
