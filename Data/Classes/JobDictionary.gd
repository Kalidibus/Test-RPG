extends Node

var job_dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	job_dictionary = {
		"0" = {"name" = "Fortress", "node" = $"Fortress", "resource" = "res://Classes/Fortress/Fortress.tscn", "splash" = "res://Assets/Classes/Fortress-splash.png"},
		"1" = {"name" = "Fel Mage", "node" = $"/root/JobDictionary/Fel Mage", "resource" = "res://Classes/Fel Mage/Fel Mage.tscn", "splash" = "res://Assets/Classes/Fel Mage-splash.png"},
		"2" = {"name" = "Bastard Fist", "node" = $"Bastard Fist", "resource" = "res://Classes/Bastard Fist/Bastard Fist.tscn", "splash" = "res://Assets/Classes/Bastard Fist-splash.png"},
		"3" = {"name" = "Shade Hunter", "node" = $"Shade Hunter", "resource" = "res://Classes/Shade Hunter/Shade Hunter.tscn", "splash" = "res://Assets/Classes/Shade Hunter-splash.png"},
		"4" = {"name" = "Erde Cleric", "node" = $"Erde Cleric", "resource" = "res://Classes/Erde Cleric/Erde Cleric.tscn", "splash" = "res://Assets/Classes/Cleric-splash.png"},
		"5" = {"name" = "Dancer", "node" = $"Dancer", "resource" = "res://Classes/Dancer/Dancer.tscn", "splash" = "res://Assets/Classes/Dancer/Dancer-splash.png"},
		"6" = {"name" = "Illusionist", "node" = $"Illusionist", "resource" = "res://Classes/Illusionist/Illusionist.tscn", "splash" = "res://Assets/Classes/Illusionist/Illusionist-splash.png"},
		"7" = {"name" = "Samurai", "node" = $"Samurai", "resource" = "res://Classes/Saumrai/Samurai.tscn", "splash" = "res://Assets/Classes/Samurai/Samurai-splash.png"},
		"8" = {"name" = "War Mage", "node" = $"War Mage", "resource" = "res://Classes/War Mage/War Mage.tscn", "splash" = "res://Assets/Classes/War Mage/War Mage-splash.png"}

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
	
func JobSplash(jobid):
	return job_dictionary[str(jobid)]["splash"]

func JobDesc(jobid):
	return job_dictionary[str(jobid)]["node"].job_description

func GetUnlocks(jobid):
	return $UnlockRequirements.req[jobid]
