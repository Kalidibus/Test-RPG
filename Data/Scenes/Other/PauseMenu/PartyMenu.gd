extends MarginContainer

@onready var partyblock = preload("res://Scenes/Other/PauseMenu/PartyBlock.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in PlayerData.roster:
		var block = partyblock.instantiate()
		block.get_node("%Name").text = PlayerData.roster[n]["name"]
		block.get_node("%Class").text = PlayerData.roster[n]["job_name"]
		
		%PartyBlockHolder.add_child(block)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
