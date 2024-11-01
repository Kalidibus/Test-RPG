extends MarginContainer

var currentscreen = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var menu = load("res://Scenes/Other/PauseMenu/PartyMenu.tscn")
	ClearScreen()
	%MenuContainer.add_child(menu.instantiate())
	currentscreen = "party"


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
		get_tree().change_scene_to_file("res://Scenes/Start.tscn")


func _on_party_button_pressed() -> void:
	if not currentscreen == "party":
		var menu = load("res://Scenes/Other/PauseMenu/PartyMenu.tscn")
		ClearScreen()
		%MenuContainer.add_child(menu.instantiate())
		currentscreen = "party"
