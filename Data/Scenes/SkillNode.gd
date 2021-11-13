extends MarginContainer
class_name SkillNode

func _ready():
	pass

func SetSkill(skillname, skilldesc):
	$Button/HBoxContainer/SkillName.text = skillname
	$Button/HBoxContainer/SkillDesc.text = skilldesc
	#include some kind of ability target here, so when this button is pushed it can trigger the correct script on the base unit
