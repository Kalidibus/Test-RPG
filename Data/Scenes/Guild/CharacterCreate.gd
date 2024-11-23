extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	%OptionButton.select(0)
	CharaDetails(0)
	%BackButton.disabled = true
	%UserEnteredName.grab_focus()
	
	#Disables options that aren't unlocked yet
	#%OptionButton


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Start.tscn")

func _on_create_char_button_pressed() -> void:
	var newcharid
	var user_entered_name = %UserEnteredName.text
	var user_selected_job = %OptionButton.selected
	var cost = JobDict.GetHireCost(user_selected_job)
	
	if not PlayerData.inventory.has(ItemDict.item.comp1) or PlayerData.inventory[ItemDict.item.comp1] < cost:
		Globals.system_message("Not enough " +ItemDict.GetItemName(ItemDict.item.comp1) + " to hire.")
		return
	
	if not user_entered_name:
		Globals.system_message("No name entered!")
		return
	
	if user_selected_job == -1:
		Globals.system_message("No job selected!")
		return
	
	var choice = await Globals.system_message_choice("Spend " + str(cost) + " " + ItemDict.GetItemName(ItemDict.item.comp1) + " to hire " + str(user_entered_name) + "?", "Yes", "No")
	if choice == "right": return
	
	#look at current roster. Look at the last Character ID created and add +1 for the new character. Checks for empty roster. 
	if PlayerData.roster.size() == 0:
		newcharid = 0
	else:
		newcharid = int(PlayerData.roster.keys()[-1]) + 1
	
	#main function to add the new character using the Character ID generated above.
	PlayerData.roster[str(newcharid)] = {
		"name" = str(user_entered_name),
		"char_id" = str(newcharid),
		"job_id" = str(user_selected_job),
		"job_name" = JobDict.JobName(user_selected_job),
		"level" = 1,
		"row" = Entity.row_line.FRONT,
		"xp" = 0,
		"xpneeded" = 100,
		"gear_statmods" = {},
		"stats" = JobDict.Starting_Stats(user_selected_job),
		"known_skills" = [],
		"skill_levels" = {},
		"equipment" = {
			"main_hand": "",
			"off_hand":  "",
			"head":  "",
			"body":  "",
			"gloves": "",
			"pants": "",
			"necklace": "",
			"ring_1": "",
			"ring_2": ""
		},
		"status" = {},
		"combatlabel" = null,
		"combatnode" = null
	}
	#give starting equipment
	CharacterChanges.add_equipment(newcharid, "head", ItemDict.item.head1, "roster")
	CharacterChanges.add_equipment(newcharid, "body", ItemDict.item.body1, "roster")
	CharacterChanges.add_equipment(newcharid, "main_hand", ItemDict.item.sword1, "roster")
	
	#pay hiring price
	CharacterChanges.RemovefromInventory(ItemDict.item.comp1, cost)
	
	#Create success pop-up dialogue
	if AutoAddtoParty(PlayerData.roster[str(newcharid)]) == false:
		var choice2 = await Globals.system_message_choice("Successfully hired " + user_entered_name + " as a " + JobDict.JobName(user_selected_job) + "!\nWould you like to adjust your current party now?", "Yes", "No")
		if choice2 == "left": get_tree().change_scene_to_file("res://Scenes//Guild/PartyBuild.tscn")


#If the party isn't full, automatically add the new character. Mostly to stop annoying me during testing. 
func AutoAddtoParty(new_char):
	if PlayerData.party.size() < 5: 
		Globals.system_message("Successfully hired " + new_char["name"] + "!\nAutomatically added to your party!")
		PlayerData.party[new_char["char_id"]] = PlayerData.roster[new_char["char_id"]]
		PlayerData.party_order.append(new_char["char_id"])
		return true
	else: return false

			

func _on_option_button_item_selected(index: int) -> void:
	CharaDetails(index)

func _on_char_unlock_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes//Guild/Unlocks.tscn")

func CharaDetails(index: int) -> void:
	#the value of "index" is the same as the job IDs defined in the job dictionary. This function compares against that for what it needs.
	
	#Set the splash image.
	%CharaSplash.set_texture(load(JobDict.JobSplash(index)))
	
	#Very clunky way to grab individual stats and update them. could use a "for n in Stats.get_children() but whatever this works.
	%HP_stat.text = str(JobDict.Stats(index)[Entity.stat.HP])
	%MP_stat.text = str(JobDict.Stats(index)[Entity.stat.MP])
	%STR_stat.text = str(JobDict.Stats(index)[Entity.stat.STR])
	%DEF_stat.text = str(JobDict.Stats(index)[Entity.stat.DEF])
	%INT_stat.text = str(JobDict.Stats(index)[Entity.stat.INT])
	%FTH_stat.text = str(JobDict.Stats(index)[Entity.stat.FTH])
	%RES_stat.text = str(JobDict.Stats(index)[Entity.stat.RES])
	%EVD_stat.text = str(JobDict.Stats(index)[Entity.stat.EVD])
	%SPD_stat.text = str(JobDict.Stats(index)[Entity.stat.SPD])
	
	#Set the name
	%job_name_display.text = JobDict.JobName(index)
	%job_description_display.text = JobDict.JobDesc(index)

func _on_back_button_pressed() -> void:
	var index = %OptionButton.get_selected_id()
	index -= 1
	%OptionButton.select(index)
	index = %OptionButton.get_selected_id()
	CharaDetails(index)
	
	%ForwardButton.disabled = false
	
	CheckUnlocked(index)
	
	if index == 0:
		%BackButton.disabled = true

func _on_forward_button_pressed() -> void:
	var index = %OptionButton.get_selected_id()
	index += 1
	%OptionButton.select(index)
	index = %OptionButton.get_selected_id()
	CharaDetails(index)
	
	%BackButton.disabled = false
	
	CheckUnlocked(index)
	
	if index == JobDict.job_dictionary.size() -1:
		%ForwardButton.disabled = true

func CheckUnlocked(index):
	if not PlayerData.IsClassUnlocked(index): 
		%CreateCharButton.disabled = true
		%CreateCharButton.text = "Class is not Unlocked!"
	else: 
		%CreateCharButton.disabled = false
		%CreateCharButton.text = "Create a new Character"


func _on_adjust_party_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes//Guild/PartyBuild.tscn")


func _on_skills_button_pressed() -> void:
	if not PlayerData.party:
		Globals.system_message("Party has not yet been created")
		return
	else:
		get_tree().change_scene_to_file("res://Scenes/Guild/SkillVendor/SkillTreeMenu.tscn")
