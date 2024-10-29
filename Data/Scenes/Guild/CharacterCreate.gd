extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%UserEnteredName.grab_focus()
	#%OptionButton.select(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Start.tscn")

func _on_create_char_button_pressed() -> void:
	var newcharid
	var user_entered_name = %UserEnteredName.text
	var user_selected_job = %OptionButton.selected
	
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

	#Create success pop-up dialogue
	Globals.system_message("Successfully hired " + user_entered_name + " as a " + JobDictionary.JobName(user_selected_job) + "!\nWelcome to the team.")

func _on_option_button_item_selected(index: int) -> void:
	#the value of "index" is the same as the job IDs defined in the job dictionary. This function compares against that for what it needs.
	
	#Set the splash image.
	%CharaSplash.set_texture(load(JobDictionary.JobSplash(index)))
	
	#Very clunky way to grab individual stats and update them. could use a "for n in Stats.get_children() but whatever this works.
	%HP_stat.text = str(JobDictionary.Stats(index)["HP"])
	%MP_stat.text = str(JobDictionary.Stats(index)["MP"])
	%STR_stat.text = str(JobDictionary.Stats(index)["STR"])
	%DEF_stat.text = str(JobDictionary.Stats(index)["DEF"])
	%INT_stat.text = str(JobDictionary.Stats(index)["INT"])
	%FTH_stat.text = str(JobDictionary.Stats(index)["FTH"])
	%RES_stat.text = str(JobDictionary.Stats(index)["RES"])
	%EVD_stat.text = str(JobDictionary.Stats(index)["EVD"])
	%SPD_stat.text = str(JobDictionary.Stats(index)["SPD"])
	
	#Set the name
	%job_name_display.text = JobDictionary.JobName(index)
	%job_description_display.text = JobDictionary.JobDesc(index)
