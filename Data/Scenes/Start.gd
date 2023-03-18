extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/HBoxContainer/VBoxContainer/StartButton").grab_focus()

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/Battle Scenes/Combat.tscn")

func _on_OptionsButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/Dungeon/World.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()







