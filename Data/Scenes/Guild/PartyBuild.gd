extends MarginContainer

@onready var partyblock = preload("res://Scenes/Guild/RosterPartyBlock.tscn")
var current_selection = "none selected"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GetBlockData()

func ClearBlocks():
	for n in %PartyBlockHolder.get_children():
		n.queue_free()
	for n in %RosterBlockHolder.get_children():
		n.queue_free()

func GetBlockData():
	for n in PlayerData.party:
		AddBlocks("party", n)
	for n in PlayerData.roster:
		AddBlocks("roster", n)

func AddBlocks(location, n):
	var block = partyblock.instantiate()
	var char = PlayerData.get(location)[n]
	block.charid = n
	
	#hides party members from roster without actually removing them
	if PlayerData.party.has(n) and location == "roster": 
		block.visible = false
		
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
	
	if location == "party": %PartyBlockHolder.add_child(block)
	if location == "roster":%RosterBlockHolder.add_child(block)


func _on_addto_party_pressed() -> void:
	for n in %RosterBlockHolder.get_children():
		if n.charid == current_selection:
			PlayerData.party[n.charid] = PlayerData.roster[n.charid]
			PlayerData.party_order.append(n.charid)
			ClearBlocks()
			GetBlockData()
			
			

func _on_addto_roster_pressed() -> void:
	for n in %PartyBlockHolder.get_children():
		if n.charid == current_selection:
			PlayerData.party.erase(n.charid)
			ClearBlocks()
			GetBlockData()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Guild/CharacterCreate.tscn")
