extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_unlock_gui(jobid):
	var dict = JobDictionary.GetUnlocks(jobid)
	var itemid
	var needed
	
	#resource 1
	itemid = dict["0"]["itemid"]
	needed = dict["0"]["needed"]
	#%res1icon = ItemDict.GetIcon(itemid)
	%res1name.text = ItemDict.GetItemName(itemid)
	%res1current.text = str(PlayerData.GetInvItemQty(itemid))
	%res1need.text = str(needed)

	#resource 2
	itemid = dict["1"]["itemid"]
	needed = dict["1"]["needed"]
	#%res2icon = ItemDict.GetIcon(itemid)
	%res2name.text = ItemDict.GetItemName(itemid)
	%res2current.text = str(PlayerData.GetInvItemQty(itemid))
	%res2need.text = str(needed)
	
	#resource 3
	itemid = dict["2"]["itemid"]
	needed = dict["2"]["needed"]
	#%res3icon = ItemDict.GetIcon(itemid)
	%res3name.text = ItemDict.GetItemName(itemid)
	%res3current.text = str(PlayerData.GetInvItemQty(itemid))
	%res3need.text = str(needed)
	
	#resource 4
	itemid = dict["3"]["itemid"]
	needed = dict["3"]["needed"]
	#%res4icon = ItemDict.GetIcon(itemid)
	%res4name.text = ItemDict.GetItemName(itemid)
	%res4current.text = str(PlayerData.GetInvItemQty(itemid))
	%res4need.text = str(needed)


func _on_unlock_button_pressed() -> void:
	var jobid = self.get_index()
	
	if PaythePrice(jobid):

		PlayerData.UnlockClass(jobid)
		%UnlockButton.disabled = true
	
		%unlockstatus.text = "Unlocked!"
		%ResourceContainer.visible = false
		%UnlockButton.disabled = true
		
		$/root/CharUnlocks.get_tree().reload_current_scene()

func PaythePrice(jobid):
	var costarray = JobDictionary.GetUnlocks(str(jobid))
	var count = 0

	for n in costarray:
		var cost = costarray[n]["needed"]
		var item = costarray[n]["itemid"]


		if PlayerData.GetInvItemQty(item) >= cost:
			count += 1
	if count == 4:
		for n in costarray:
			var item = costarray[n]["itemid"]
			var cost = costarray[n]["needed"]
			
			ItemDict.RemovefromInventory(item, cost)
			
			Globals.system_message(JobDictionary.JobName(jobid) + " has been unlocked!")
		return 1
	else:
		Globals.system_message("Inadequate Resources")
		return 0
	

	
