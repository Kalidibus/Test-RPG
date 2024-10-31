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
	if PaythePrice():
		var jobid = self.get_index()
		PlayerData.UnlockClass(jobid)
		%UnlockButton.disabled = true
		print(PlayerData.unlocked_classes)
	
		%unlockstatus.text = "Unlocked!"
		%ResourceContainer.visible = false
		%UnlockButton.disabled = true

func PaythePrice():
	var jobid = self.get_index()
	print(jobid)
	var cost = JobDictionary.GetUnlocks(str(jobid))
	
#	for n in cost:
#		print(n)
#		if PlayerData.GetInvItemQty(n) > cost[n]:
#			print("yes")
	
	print(cost) 
	
	ItemDict.RemovefromInventory("lcom001", 5)
	
