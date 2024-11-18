extends Node

var job_dictionary
enum resources {charname, node, resource, splash, splash_pos, profile, label}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	job_dictionary = {
		"0" = {resources.charname: "Fortress",
			resources.node: $"Fortress",
			resources.resource: "res://Classes/Fortress/Fortress.tscn",
			resources.splash: "res://Assets/Classes/Fortress/Fortress-splash.png",
			resources.splash_pos: Vector2(1596, 511),
			resources.profile: "res://Assets/Classes/Fortress/Fortress-profile.png",
			resources.label: "res://Assets/Classes/Fortress/Fortress-PartyLabel.png"},
		"1" = {resources.charname: "Fel Mage",
			resources.node: $"Fel Mage",
			resources.resource: "res://Classes/Fel Mage/Fel Mage.tscn",
			resources.splash: "res://Assets/Classes/Fel Mage/Fel Mage-splash.png",
			resources.splash_pos: Vector2(1599, 443),
			resources.profile: "res://Assets/Classes/Fel Mage/Fel Mage-profile.png",
			resources.label: "res://Assets/Classes/Fel Mage/Fel Mage-PartyLabel.png"},
		"2" = {resources.charname: "Bastard Fist",
			resources.node: $"Bastard Fist",
			resources.resource: "res://Classes/Bastard Fist/Bastard Fist.tscn",
			resources.splash: "res://Assets/Classes/Bastard Fist/Bastard Fist-splash.png",
			resources.splash_pos: Vector2(1577, 609),
			resources.profile: "res://Assets/Classes/Bastard Fist/Bastard Fist-profile.png",
			resources.label: "res://Assets/Classes/Bastard Fist/Bastard Fist-PartyLabel.png"},
		"3" = {resources.charname: "Shade Hunter",
			resources.node: $"Shade Hunter",
			resources.resource: "res://Classes/Shade Hunter/Shade Hunter.tscn",
			resources.splash: "res://Assets/Classes/Shade Hunter/Shade Hunter-splash.png",
			resources.splash_pos: Vector2(1720, 473),
			resources.profile: "res://Assets/Classes/Shade Hunter/Shade Hunter-profile.png",
			resources.label: "res://Assets/Classes/Shade Hunter/Shade Hunter-PartyLabel.png"},
		"4" = {resources.charname: "Erde Cleric",
			resources.node: $"Erde Cleric",
			resources.resource: "res://Classes/Erde Cleric/Erde Cleric.tscn",
			resources.splash: "res://Assets/Classes/Erde Cleric/Cleric-splash.png",
			resources.splash_pos: Vector2(1596, 511),
			resources.profile: "res://Assets/Classes/Erde Cleric/Cleric-profile.png",
			resources.label: "res://Assets/Classes/Erde Cleric/Cleric-PartyLabel.png"},
		"5" = {resources.charname: "Dancer",
			resources.node: $"Dancer",
			resources.resource: "res://Classes/Dancer/Dancer.tscn",
			resources.splash: "res://Assets/Classes/Dancer/Dancer-splash.png",
			resources.splash_pos: Vector2(1596, 511),
			resources.profile: "res://Assets/Classes/Dancer/Dancer-profile.png",
			resources.label: "res://Assets/Classes/TBD-PartyLabel.png"},
		"6" = {resources.charname: "Illusionist",
			resources.node: $"Illusionist",
			resources.resource: "res://Classes/Illusionist/Illusionist.tscn",
			resources.splash: "res://Assets/Classes/Illusionist/Illusionist-splash.png",
			resources.splash_pos: Vector2(1596, 511),
			resources.profile: "res://Assets/Classes/Illusionist/Illusionist-profile.png",
			resources.label: "res://Assets/Classes/TBD-PartyLabel.png"},
		"7" = {resources.charname: "Samurai",
			resources.node: $"Samurai",
			resources.resource: "res://Classes/Saumrai/Samurai.tscn",
			resources.splash: "res://Assets/Classes/Samurai/Samurai-splash.png",
			resources.splash_pos: Vector2(1596, 511),
			resources.profile: "res://Assets/Classes/Samurai/Samurai-profile.png",
			resources.label: "res://Assets/Classes/TBD-PartyLabel.png"},
		"8" = {resources.charname: "War Mage",
			resources.node: $"War Mage",
			resources.resource: "res://Classes/War Mage/War Mage.tscn",
			resources.splash: "res://Assets/Classes/War Mage/War Mage-splash.png",
			resources.splash_pos: Vector2(1596, 511),
			resources.profile: "res://Assets/Classes/War Mage/War Mage-profile.png",
			resources.label: "res://Assets/Classes/TBD-PartyLabel.png"},

}

func Stats(jobid):
	return job_dictionary[str(jobid)][resources.node].starting_stats

func StatScaling(jobid, stat):
	var statscale = job_dictionary[str(jobid)][resources.node].stat_scaling[stat]
	match statscale:
		"S": return 1.1
		"A": return 1.08
		"B": return 1.06
		"C": return 1.05
		"D": return 1.04
		"E": return 1.02
		"F": return 1
		
		
func JobName(jobid):
	return job_dictionary[str(jobid)][resources.charname]

func JobNode(jobid):
	return job_dictionary[str(jobid)][resources.node]

func JobSplash(jobid):
	return job_dictionary[str(jobid)][resources.splash]

func JobLabel(jobid):
	return job_dictionary[str(jobid)][resources.label]

func JobDesc(jobid):
	return job_dictionary[str(jobid)][resources.node].job_description

func GetUnlocks(jobid):
	return $UnlockRequirements.req[jobid]

func GetHireCost(jobid):
	return job_dictionary[str(jobid)][resources.node].hire_cost

func GetSkills(jobid):
	return job_dictionary[str(jobid)][resources.node].skill_list

func JobProfile(jobid):
	return job_dictionary[str(jobid)][resources.profile]
	
func JobSplashPOS(jobid):
	return job_dictionary[str(jobid)][resources.splash_pos]
