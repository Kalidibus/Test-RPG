extends MarginContainer

var currentscreen = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var menu = load("res://Scenes/Other/PauseMenu/PartyMenu.tscn")
	ClearScreen()
	%MenuContainer.add_child(menu.instantiate())
	currentscreen = "party"
	
	#This prevents the escape key from getting read too early and closing the pause menu immediately 
	await get_tree().create_timer(0.2).timeout
	$Timer.start()


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
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://Scenes/Dungeon/World.tscn")


func _on_party_button_pressed() -> void:
	if not currentscreen == "party":
		var menu = load("res://Scenes/Other/PauseMenu/PartyMenu.tscn")
		ClearScreen()
		%MenuContainer.add_child(menu.instantiate())
		currentscreen = "party"

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Start.tscn")

#This function checks for Escape key being hit during pause menun and returns to world. Update to be generic so you can return to anywhere. 
#Requires a Timer node (see this scene for example)
func _on_timer_timeout() -> void:
	var Escape := Input.is_action_pressed("Escape")

	if Escape:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Dungeon/World.tscn")
