extends MarginContainer

@onready var partyblock = preload("res://Scenes/Other/PauseMenu/PartyBlock.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in PlayerData.party:
		var char = PlayerData.party[n]
		var block = partyblock.instantiate()
		block.get_node("%Name").text = char["name"]
		block.get_node("%Class").text = char["job_name"]
		block.get_node("%XP").text = "XP: " + str(char["xp"]) + "/" + str(char["xpneeded"])
		block.get_node("%Lv").text = "Lv. " + str(char["level"])
		
		var HP = PlayerData.GetStat(n, "HP")
		var HPmax = PlayerData.GetStat(n, "HPmax")
		var MP = PlayerData.GetStat(n, "MP")
		var MPmax = PlayerData.GetStat(n, "MPmax")
		
		block.get_node("%HP").text = str(HP) + "/" + str(HPmax)
		block.get_node("%MP").text = str(MP) + "/" + str(MPmax)
		block.get_node("%HPBar").min_value = HP
		block.get_node("%HPBar").max_value = HPmax
		block.get_node("%MPBar").min_value = MP
		block.get_node("%MPBar").max_value = MPmax
		
		block.get_node("%STR_stat").text = str(PlayerData.GetStat(n, "STR"))
		block.get_node("%DEF_stat").text = str(PlayerData.GetStat(n, "DEF"))
		block.get_node("%INT_stat").text = str(PlayerData.GetStat(n, "INT"))
		block.get_node("%RES_stat").text = str(PlayerData.GetStat(n, "RES"))
		block.get_node("%FTH_stat").text = str(PlayerData.GetStat(n, "FTH"))
		block.get_node("%EVD_stat").text = str(PlayerData.GetStat(n, "EVD"))
		block.get_node("%SPD_stat").text = str(PlayerData.GetStat(n, "SPD"))
		
		%PartyBlockHolder.add_child(block)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
