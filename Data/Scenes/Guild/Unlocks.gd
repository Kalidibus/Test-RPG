extends MarginContainer

@onready var box = preload("res://Scenes/Guild/UnlockGUIBox.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var count = 0 
	
	while count < JobDictionary.job_dictionary.size():
		var guibox = box.instantiate()
		%ListBox.add_child(guibox)
		var child = %ListBox.get_child(count)
		
		#Fills in "Class Name part of block
		child.get_node("%classname").text = JobDictionary.job_dictionary[str(count)]["name"]
		
		#Checks if unlocked or not
		if PlayerData.IsClassUnlocked(count):
			child.get_node("%unlockstatus").text = "Unlocked!"
			child.get_node("%ResourceContainer").visible = false
			child.get_node("%UnlockButton").disabled = true
		else:
			child.get_node("%unlockstatus").text = "Not yet Available"
		
		child.set_unlock_gui(str(count))
		count += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Guild/CharacterCreate.tscn")


func _on_givestuff_pressed() -> void:
	ItemDict.AddtoInventory("lcom001", 5)
	ItemDict.AddtoInventory("lcom002", 5)
	ItemDict.AddtoInventory("lcom003", 5)
	ItemDict.AddtoInventory("lcom004", 5)
	print(PlayerData.inventory)
	get_tree().reload_current_scene()

func _on_takestuff_pressed() -> void:
	ItemDict.RemovefromInventory("lcom001", 5)
	ItemDict.RemovefromInventory("lcom002", 5)
	ItemDict.RemovefromInventory("lcom003", 5)
	ItemDict.RemovefromInventory("lcom004", 5)
	print(PlayerData.inventory)
	get_tree().reload_current_scene()
