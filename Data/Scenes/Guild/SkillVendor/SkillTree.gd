extends Control
class_name SkillTree

var character_class = 0 #needs to be updated by parent script to determine which skills to pull in. 
var character_id = "0"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FillTree(character_class) 

func FillTree(jobid):
	var skills = JobDict.GetSkills(jobid)
	var count = 1
	
	for skill in skills:
		var node = get_node("%Skill" + str(count))
		node.GetSkillInfo(skill, skills[skill])
		for known in PlayerData.party[character_id]["known_skills"]:
			if skill == known:
				node.current_level = PlayerData.party[character_id]["skill_levels"][skill]
		node.RefreshInfo()
		count += 1
