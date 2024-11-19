extends Control
class_name SkillTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FillTree(0)

func FillTree(jobid):
	var skills = JobDict.GetSkills(jobid)
	var count = 1
	
	for skill in skills:
		var node = get_node("%Skill" + str(count))
		node.GetSkillInfo(skills[skill])
		print(skill)
		count += 1
