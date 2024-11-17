extends Node
enum enemy {PYLON, BRAINROT}
var enemydict 
enum zone {ARID, DEEP}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemydict = {
	enemy.PYLON: {"id" = enemy.PYLON, "node" = %mon_pylon, "zone" = zone.ARID, "image" = "res://Assets/Enemies/Plyon.png"},
	enemy.BRAINROT: {"id" = enemy.BRAINROT, "node" = %mon_brainrot, "zone" = zone.ARID, "image" = "res://Assets/Enemies/Brain Rot.png"},
}

func GetEncounter(area):
	return get_node(area).Encounters()
	
func GetStat(monid, stat):
	var node = enemydict[monid]["node"]
	var stat_to_return = get_node("%" + str(node)).stats[stat]
	return stat_to_return

func GetAllStats(monid):
	var node = enemydict[monid]["node"]
	var stats = get_node("%" + str(node)).stats
	return stats

func GetName(monid):
	var node = enemydict[monid]["node"]
	var name = get_node("%" + str(node)).charname
	return name

func GetNode(monid):
	return enemydict[monid]["node"]

func GetImage(monid):
	return enemydict[monid]["image"]
	
func GetRow(monid):
	var node = enemydict[monid]["node"]
	var row = get_node("%" + str(node)).row
	return row
