extends Node

var job_dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	job_dictionary = {
		"0" = {"name" = "Fortress",
			"node" = $"Fortress",
			"resource" = "res://Classes/Fortress/Fortress.tscn",
			"splash" = "res://Assets/Classes/Fortress/Fortress-splash.png",
			"profile" = "res://Assets/Classes/Fortress/Fortress-profile.png",
			"label" = "res://Assets/Classes/Fortress/Fortress-PartyLabel.png"},
		"1" = {"name" = "Fel Mage",
			"node" = $"Fel Mage",
			"resource" = "res://Classes/Fel Mage/Fel Mage.tscn",
			"splash" = "res://Assets/Classes/Fel Mage/Fel Mage-splash.png",
			"profile" = "res://Assets/Classes/Fel Mage/Fel Mage-profile.png",
			"label" = "res://Assets/Classes/Fel Mage/Fel Mage-PartyLabel.png"},
		"2" = {"name" = "Bastard Fist",
			"node" = $"Bastard Fist",
			"resource" = "res://Classes/Bastard Fist/Bastard Fist.tscn",
			"splash" = "res://Assets/Classes/Bastard Fist/Bastard Fist-splash.png",
			"profile" = "res://Assets/Classes/Bastard Fist/Bastard Fist-profile.png",
			"label" = "res://Assets/Classes/Bastard Fist/Bastard Fist-PartyLabel.png"},
		"3" = {"name" = "Shade Hunter",
			"node" = $"Shade Hunter",
			"resource" = "res://Classes/Shade Hunter/Shade Hunter.tscn",
			"splash" = "res://Assets/Classes/Shade Hunter/Shade Hunter-splash.png",
			"profile" = "res://Assets/Classes/Shade Hunter/Shade Hunter-profile.png",
			"label" = "res://Assets/Classes/Shade Hunter/Shade Hunter-PartyLabel.png"},
		"4" = {"name" = "Erde Cleric",
			"node" = $"Erde Cleric",
			"resource" = "res://Classes/Erde Cleric/Erde Cleric.tscn",
			"splash" = "res://Assets/Classes/Erde Cleric/Cleric-splash.png",
			"profile" = "res://Assets/Classes/Erde Cleric/Cleric-profile.png",
			"label" = "res://Assets/Classes/Erde Cleric/Cleric-PartyLabel.png"},
		"5" = {"name" = "Dancer",
			"node" = $"Dancer",
			"resource" = "res://Classes/Dancer/Dancer.tscn",
			"splash" = "res://Assets/Classes/Dancer/Dancer-splash.png",
			"profile" = "res://Assets/Classes/Dancer/Dancer-profile.png",
			"label" = "res://Assets/Classes/TBD-PartyLabel.png"},
		"6" = {"name" = "Illusionist",
			"node" = $"Illusionist",
			"resource" = "res://Classes/Illusionist/Illusionist.tscn",
			"splash" = "res://Assets/Classes/Illusionist/Illusionist-splash.png",
			"profile" = "res://Assets/Classes/Illusionist/Illusionist-profile.png",
			"label" = "res://Assets/Classes/TBD-PartyLabel.png"},
		"7" = {"name" = "Samurai",
			"node" = $"Samurai",
			"resource" = "res://Classes/Saumrai/Samurai.tscn",
			"splash" = "res://Assets/Classes/Samurai/Samurai-splash.png",
			"profile" = "res://Assets/Classes/Samurai/Samurai-profile.png",
			"label" = "res://Assets/Classes/TBD-PartyLabel.png"},
		"8" = {"name" = "War Mage",
			"node" = $"War Mage",
			"resource" = "res://Classes/War Mage/War Mage.tscn",
			"splash" = "res://Assets/Classes/War Mage/War Mage-splash.png",
			"profile" = "res://Assets/Classes/War Mage/War Mage-profile.png",
			"label" = "res://Assets/Classes/TBD-PartyLabel.png"},

}
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Stats(jobid):
	return job_dictionary[str(jobid)]["node"].starting_stats

func StatScaling(jobid, stat):
	var statscale = job_dictionary[str(jobid)]["node"].stat_scaling[stat]
	match statscale:
		"S": return 1.1
		"A": return 1.08
		"B": return 1.06
		"C": return 1.05
		"D": return 1.04
		"E": return 1.02
		"F": return 1
		
		
func JobName(jobid):
	return job_dictionary[str(jobid)]["name"]

func JobNode(jobid):
	return job_dictionary[str(jobid)]["node"]

func JobSplash(jobid):
	return job_dictionary[str(jobid)]["splash"]

func JobLabel(jobid):
	return job_dictionary[str(jobid)]["label"]

func JobDesc(jobid):
	return job_dictionary[str(jobid)]["node"].job_description

func GetUnlocks(jobid):
	return $UnlockRequirements.req[jobid]

func GetHireCost(jobid):
	return job_dictionary[str(jobid)]["node"].hire_cost

func GetSkills(jobid):
	return job_dictionary[str(jobid)]["node"].skill_list
