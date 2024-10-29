extends Node

var job_dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	job_dictionary = {
		"0" = {"name" = "Fortress", "node" = $"Fortress", "splash" = "res://Assets/Classes/Fortress-splash.png"},
		"1" = {"name" = "Fel Mage", "node" = $"Fel Mage", "splash" = "res://Assets/Classes/Fel Mage-splash.png"},
		"2" = {"name" = "Bastard Fist", "node" = $"Bastard Fist", "splash" = "res://Assets/Classes/Bastard Fist-splash.png"},
		"3" = {"name" = "Shade Hunter", "node" = $"Shade Hunter", "splash" = "res://Assets/Classes/Shade Hunter-splash.png"},
		"4" = {"name" = "Erde Cleric", "node" = $"Forest Healer", "splash" = "res://Assets/Classes/Cleric-splash.png"},
		"5" = {"name" = "Dancer", "node" = $"Dancer", "splash" = "res://Assets/Classes/TBD-splash.png"},
		"6" = {"name" = "Illusionist", "node" = $"Illusionist", "splash" = "res://Assets/Classes/Illusionist/Illusionist-splash.png"},
		"7" = {"name" = "Samurai", "node" = $"Samurai", "splash" = "res://Assets/Classes/Samurai/Samurai-splash.png"},
		"8" = {"name" = "War Mage", "node" = $"War Mage", "splash" = "res://Assets/Classes/War Mage/War Mage-splash.png"}

}
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Stats(jobid):
	return job_dictionary[str(jobid)]["node"].starting_stats

func JobName(jobid):
	return job_dictionary[str(jobid)]["name"]
	
func JobSplash(jobid):
	return job_dictionary[str(jobid)]["splash"]

func JobDesc(jobid):
	return job_dictionary[str(jobid)]["node"].job_description
