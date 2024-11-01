extends MarginContainer

var currentscreen = "party"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ClearScreen() -> void:
	%MenuContainer.remove_child(%MenuContainer.get_child(1))

func _on_items_button_pressed() -> void:
	if not currentscreen == "items":
		var menu = load("res://Scenes/Other/PauseMenu/ItemMenu.tscn")
		ClearScreen()
		%MenuContainer.add_child(menu.instantiate())
		currentscreen = "items"




func _on_options_button_pressed() -> void:
	if not currentscreen == "options":
		var menu = load("res://Scenes/Other/PauseMenu/OptionsMenu.tscn")
		ClearScreen()
		%MenuContainer.add_child(menu.instantiate())
		currentscreen = "options"
	
func _on_quit_button_pressed() -> void:
	var choice = await Globals.system_message_choice("Do you wish to save your game before quitting?", "Yes", "No")
	if choice == "left":
		await SaveandLoad.save_file()
		get_tree().change_scene_to_file("res://Scenes/Start.tscn")
	if choice == "right":
		get_tree().change_scene_to_file("res://Scenes/Start.tscn")
