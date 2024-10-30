extends MarginContainer

func _ready():
	get_node("VBoxContainer/HBoxContainer/VBoxContainer/StartButton").grab_focus()

func _on_StartButton_pressed():
	if not PlayerData.roster:
		Globals.system_message("Party has not yet been created")
		return
	else: 
		get_tree().change_scene_to_file("res://Scenes/Battle Scenes/Combat.tscn")

func _on_OptionsButton_pressed():
	if not PlayerData.roster:
		Globals.system_message("Party has not yet been created")
		return
	else: 
		get_tree().change_scene_to_file("res://Scenes/Dungeon/World.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_save_button_pressed():
	SaveandLoad.save_file()

func _on_load_button_pressed():
	SaveandLoad.load_file()

func _on_hire_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Guild/CharacterCreate.tscn")
