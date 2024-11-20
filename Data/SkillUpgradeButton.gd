extends Button
class_name SkillUpgradeButton

var current_level
var max_level
var cost_item = ItemDict.item.comp4
var cost_amount = 5
var skill_id
var char_id

@onready var skill_tree_menu: MarginContainer = $"/root/SkillTreeMenu"
@onready var cost_amount_label: Label = %CostAmount
@onready var cost_item_label: Label = %CostItem

@onready var panel: Panel = $Panel
@onready var skill_level_label: Label = %SkillLevelLabel
@onready var max_level_label: Label = %MaxLevelLabel
@onready var skill_name_label: Label = %SkillNameLabel
@onready var skill_desc_label: Label = %SkillDescLabel
@onready var line_2d: Line2D = $Line2D
@export var linked_colour: Color = Color(0.655, 0.129, 0.129)

func _ready():
	if get_parent() is SkillUpgradeButton:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)
		#RefreshInfo()

#not currently used
func RefreshInfo():
	if current_level > 0: panel.show_behind_parent = true
	skill_level_label.text = str(current_level)
	max_level_label.text = str(max_level)
	cost_amount_label.text = str(cost_amount)
	cost_item_label.text = str(ItemDict.GetItemName(cost_item))


func _on_pressed() -> void:
	if not PlayerData.inventory.has(cost_item) or not PlayerData.inventory[cost_item] > cost_amount: Globals.system_message("not enough " + ItemDict.GetItemName(cost_item))
	#elif: pass
	else:
		if current_level < max_level:
			CharacterChanges.RemovefromInventory(cost_item, cost_amount)
			skill_tree_menu.UpdateCount()
			current_level += 1
			panel.show_behind_parent = true
			skill_level_label.text = str(current_level)
			print(skill_id)
			CharacterChanges.LearnSkill(char_id, skill_id)
			
			#makes a line to connect between this node and it's parent
			line_2d.default_color = Color(0.655, 0.129, 0.129)
			
			var skills = get_children()

			for skill in skills:
				if skill is SkillUpgradeButton and current_level == max_level:
					skill.disabled = false

func GetSkillInfo(skillid, skill):
	skill_name_label.text = skill["skillname"]
	skill_desc_label.text = skill["skilldesc"]
	skill_level_label.text = str(skill["current_level"])
	max_level_label.text = str(skill["max_level"])
	current_level = skill["current_level"]
	max_level = skill["max_level"]
	
	if current_level > 0: panel.show_behind_parent = true
	
	skill_id = skillid
	char_id = skill_tree_menu.char_id

	
