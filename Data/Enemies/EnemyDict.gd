extends Node

var enemydict 
enum zone {ARID, DEEP}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemydict = {
	"e01" = {"name" = "Pylon", "node" = %mon_pylon, "zone" = zone.ARID, "row" = "front"},
	"e02" = {"name" = "Mistake", "node" = %mon_mistake, "zone" = zone.ARID, "row" = "back"},
}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	return enemydict[monid]["name"]

func GetNode(monid):
	return enemydict[monid]["node"]
