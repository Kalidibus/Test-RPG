extends Node

var enemydict 
enum zone {ARID, DEEP}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemydict = {
	"e01" = {"node" = %mon_pylon, "zone" = zone.ARID, "image" = "res://Assets/Enemies/Plyon.png"},
	"e02" = {"node" = %mon_brainrot, "zone" = zone.ARID, "image" = "res://Assets/Enemies/Brain Rot.png"},
}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func GetEncounter(area):
	return get_node(area).Encounters()
	
func GetStat(monid, stat):
	var node = enemydict[monid]["node"]
	print(monid)
	print(get_node("%" + str(node)).stats)
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
