extends MarginContainer

var charid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_pressed() -> void:
	$/root/PartyBuild.current_selection = charid
