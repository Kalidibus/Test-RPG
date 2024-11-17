extends MarginContainer

@onready var box = preload("res://Scenes/Guild/UnlockGUIBox.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var count = 0 
	
	while count < JobDict.job_dictionary.size():
		var guibox = box.instantiate()
		%ListBox.add_child(guibox)
		var child = %ListBox.get_child(count)
		
		#Fills in "Class Name part of block
		child.get_node("%classname").text = JobDict.job_dictionary[str(count)]["name"]
		
		#Checks if unlocked or not
		if PlayerData.IsClassUnlocked(count):
			child.get_node("%unlockstatus").text = "Unlocked!"
			child.get_node("%ResourceContainer").visible = false
			child.get_node("%UnlockButton").disabled = true
		else:
			child.get_node("%unlockstatus").text = "Not yet Available"
		
		child.set_unlock_gui(str(count))
		count += 1

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Guild/CharacterCreate.tscn")


func _on_givestuff_pressed() -> void:
	CharacterChanges.AddtoInventory("lcom001", 50)
	CharacterChanges.AddtoInventory("lcom002", 50)
	CharacterChanges.AddtoInventory("lcom003", 50)
	CharacterChanges.AddtoInventory("lcom004", 50)
	get_tree().reload_current_scene()

func _on_takestuff_pressed() -> void:
	CharacterChanges.RemovefromInventory("lcom001", 5)
	CharacterChanges.RemovefromInventory("lcom002", 5)
	CharacterChanges.RemovefromInventory("lcom003", 5)
	CharacterChanges.RemovefromInventory("lcom004", 5)
	get_tree().reload_current_scene()
