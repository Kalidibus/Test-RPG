extends Node

var job_dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	job_dictionary = {
		"0" = {"name" = "Fortress", "node" = $"Fortress"},
		"1" = {"name" = "Fel Mage", "node" = $"Fel Mage"},
		"2" = {"name" = "Bastard Fist", "node" = $"Bastard Fist"},
		"3" = {"name" = "Shade Hunter", "node" = $"Shade Hunter"},
		"4" = {"name" = "Forest Healer", "node" = $"Forest Healer"},
		"5" = {"name" = "Dancer", "node" = $"Dancer"},
		"6" = {"name" = "Illusionist", "node" = $"Illusionist"},
		"7" = {"name" = "Samurai", "node" = $"Samurai"}

}
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Stats(jobid):
	return job_dictionary[str(jobid)]["node"].starting_stats

func JobName(jobid):
	return job_dictionary[str(jobid)]["name"]
