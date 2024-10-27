extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/ReturnButton").grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Start.tscn")

func _on_create_char_button_pressed() -> void:
	var newcharid
	var user_entered_name = $HBoxContainer/VBoxContainer2/Name/LineEdit.text
	var user_selected_job = $HBoxContainer/VBoxContainer2/Job/OptionButton.selected
	
	if not user_entered_name:
		print("box is empty")
		return
	
	if user_selected_job == -1:
		print("no job selected")
		return
	
	#look at current roster. Look at the last Character ID created and add +1 for the new character. Checks for empty roster. 
	if Globals.roster.size() == 0:
		newcharid = 0
	else:
		newcharid = int(Globals.roster.keys()[-1]) + 1
	
	#main function to add the new character using the Character ID generated above.
	Globals.roster[str(newcharid)] = {
		"name" = str(user_entered_name),
		"job_id" = str(user_selected_job),
		"job_name" = JobDictionary.JobName(user_selected_job),
		"stats" = JobDictionary.Stats(user_selected_job),
		"abilities" = {},
		"equipment" = {
			"main_hand" = "",
			"off_hand" = "",
			"head" = "",
			"body" = "",
			"gloves" = "",
			"pants" = "",
			"necklace" = "",
			"ring_1" = "",
			"ring_2" = ""
		}
	}
	#give starting equipment
	CharacterChanges.add_equipment(newcharid, "head", "h01")
	CharacterChanges.add_equipment(newcharid, "body", "b01")
	CharacterChanges.add_equipment(newcharid, "main_hand", "w01")

	print("The following character was created:" + str(Globals.roster[str(newcharid)]))



func _on_option_button_item_selected(index: int) -> void:
	pass # Replace with function body.
