extends Node

var enemydict 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemydict = {
	"e01" = {"name" = "Pylon", "node" = %mon_pylon}
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

func GetName(monid):
	return enemydict[monid]["name"]
