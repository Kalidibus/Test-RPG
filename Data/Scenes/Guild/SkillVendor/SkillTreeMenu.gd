extends MarginContainer

@onready var cost_item: Label = %CostItem
@onready var cost_amount: Label = %CostAmount

var char_id 
var job_id
var skill_tree
var party_sequence = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GetTree()
	cost_item.text = ItemDict.GetItemName(ItemDict.item.comp4)
	cost_amount.text = str(PlayerData.GetInvItemQty(ItemDict.item.comp4))
	%BackButton.disabled = true
	if PlayerData.party_order.size() ==1: %ForwardButton.disabled = true

func GetTree():
	char_id = PlayerData.party_order[party_sequence]
	job_id = PlayerData.party[char_id]["job_id"]

	skill_tree = load(JobDict.JobSkillTree(job_id)) 
	%ScrollContainer.add_child(skill_tree.instantiate())
	FillTree()
	

func ClearTree():
	for n in %ScrollContainer.get_children():
		n.free()
	#await get_tree().create_timer(0.01).timeout

	return

func FillTree():
	var skills = JobDict.GetSkills(job_id)
	var count = 1
	var skill_tree_node = %ScrollContainer/SkillTree
	
	for skill in skills:
		var node = skill_tree_node.get_node("%Skill" + str(count))
		node.GetSkillInfo(skill, skills[skill])
		for known in PlayerData.party[char_id]["known_skills"]:
			if skill == known:
				node.current_level = PlayerData.party[char_id]["skill_levels"][skill]
		node.RefreshInfo()
		count += 1

func UpdateCount():
	cost_amount.text = str(PlayerData.GetInvItemQty(ItemDict.item.comp4))


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Guild/CharacterCreate.tscn")


func _on_back_button_pressed() -> void:
	%ForwardButton.disabled = false
	await ClearTree()
	party_sequence -= 1
	GetTree()
	if party_sequence == 0: %BackButton.disabled = true

	
func _on_forward_button_button_up() -> void:
	var size = PlayerData.party_order.size() -1
	if party_sequence < size:
		
		%BackButton.disabled = false

		await ClearTree()
		party_sequence += 1
		GetTree()
		if party_sequence == size: %ForwardButton.disabled = true
