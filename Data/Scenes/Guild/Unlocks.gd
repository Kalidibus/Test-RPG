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
		child.get_node("%classname").text = JobDict.JobName(str(count))
		
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
	CharacterChanges.AddtoInventory(ItemDict.item.comp1, 50)
	CharacterChanges.AddtoInventory(ItemDict.item.comp2, 50)
	CharacterChanges.AddtoInventory(ItemDict.item.comp3, 50)
	CharacterChanges.AddtoInventory(ItemDict.item.comp4, 50)
	get_tree().reload_current_scene()

func _on_takestuff_pressed() -> void:
	CharacterChanges.RemovefromInventory(ItemDict.item.comp1, 5)
	CharacterChanges.RemovefromInventory(ItemDict.item.comp2, 5)
	CharacterChanges.RemovefromInventory(ItemDict.item.comp3, 5)
	CharacterChanges.RemovefromInventory(ItemDict.item.comp4, 5)
	get_tree().reload_current_scene()
