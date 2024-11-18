extends MarginContainer

@onready var partyblock = preload("res://Scenes/Other/PauseMenu/PartyBlock.tscn")
@onready var skills_menu = preload("res://Scenes/Other/PauseMenu/SkillsMenu.tscn")
var skills_or_equip = "skills"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AddBlocks()
	LoadSkillsMenu()
	FillCharInfo(PlayerData.party_order.front())

func AddBlocks():
	for n in %PartyBlockHolder.get_children():
		n.queue_free()

	for n in PlayerData.party_order:
		var char = PlayerData.party[n]
		var block = partyblock.instantiate()
		block.charid = n
		block.get_node("%Name").text = char["name"]
		block.get_node("%Class").text = char["job_name"]
		block.get_node("%XP").text = "XP: " + str(char["xp"]) + "/" + str(char["xpneeded"])
		block.get_node("%Lv").text = "Lv. " + str(char["level"])
		block.get_node("%TextureRect").texture = load(JobDict.JobProfile(char["job_id"])) 
		
		
		var HP = PlayerData.GetStat(n, Entity.stat.HP)
		var HPmax = PlayerData.GetStat(n, Entity.stat.MAXHP)
		var MP = PlayerData.GetStat(n, Entity.stat.MP)
		var MPmax = PlayerData.GetStat(n, Entity.stat.MAXMP)
		
		block.get_node("%HP").text = str(HP) + "/" + str(HPmax)
		block.get_node("%MP").text = str(MP) + "/" + str(MPmax)
		block.get_node("%HPBar").max_value = HPmax
		block.get_node("%HPBar").value = HP
		block.get_node("%MPBar").max_value = MPmax
		block.get_node("%MPBar").value = MP
		
		block.get_node("%STR_stat").text = str(PlayerData.GetStat(n, Entity.stat.STR))
		block.get_node("%DEF_stat").text = str(PlayerData.GetStat(n, Entity.stat.DEF))
		block.get_node("%INT_stat").text = str(PlayerData.GetStat(n, Entity.stat.INT))
		block.get_node("%RES_stat").text = str(PlayerData.GetStat(n, Entity.stat.RES))
		block.get_node("%FTH_stat").text = str(PlayerData.GetStat(n, Entity.stat.FTH))
		block.get_node("%EVD_stat").text = str(PlayerData.GetStat(n, Entity.stat.EVD))
		block.get_node("%SPD_stat").text = str(PlayerData.GetStat(n, Entity.stat.SPD))
		
		var button = block.get_node("%PositionButton")
		if char.row == Entity.row_line.FRONT: button.text = "FRONT"
		if char.row == Entity.row_line.BACK: button.text = "BACK"
		
		%PartyBlockHolder.add_child(block)


func _on_skills_button_pressed() -> void:
	LoadSkillsMenu()

func LoadSkillsMenu():
	var menu = skills_menu.instantiate()
	for n in %Holder.get_children(): n.queue_free()
	%Holder.add_child(menu)
	skills_or_equip = "skills"

func FillCharInfo(charid):
	if skills_or_equip == "skills": FillCharInfo_Skills(charid)
	elif skills_or_equip == "equip": FillCharInfo_Equip(charid)
	
func FillCharInfo_Skills(charid):
	var skills_node = %Holder.get_node("SkillsMenu/VBoxContainer/Skills")
	for i in skills_node.get_children(): i.queue_free()
	
	for n in PlayerData.KnownSkills(charid):
		var jobid = PlayerData.party[charid]["job_id"]
		var node = JobDict.JobNode(jobid)

		var label = Label.new()
		label.text = node.skill_list[n]["skillname"]

		
		var label2 = Label.new()
		label2.text = node.skill_list[n]["skilldesc"]
		skills_node.add_child(label)
		skills_node.add_child(label2)

func FillCharInfo_Equip(charid):
	pass
