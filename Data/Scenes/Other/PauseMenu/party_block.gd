extends MarginContainer

var charid 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_position_button_pressed() -> void:
	if %PositionButton.text == "FRONT":
		%PositionButton.text = "BACK"
		PlayerData.party[charid]["row"] = "back"
	elif %PositionButton.text == "BACK":
		%PositionButton.text = "FRONT"
		PlayerData.party[charid]["row"] = "front"


func _on_up_button_pressed() -> void:
	var partymenu = get_node("/root/PauseMenu/VBoxContainer/MenuContainer/PartyMenu")
	PlayerData.MovePartyMember(charid, "up")
	partymenu.AddBlocks()

func _on_down_button_pressed() -> void:
	var partymenu = get_node("/root/PauseMenu/VBoxContainer/MenuContainer/PartyMenu")
	PlayerData.MovePartyMember(charid, "down")
	partymenu.AddBlocks()
