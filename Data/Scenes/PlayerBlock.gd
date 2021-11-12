extends HBoxContainer

var baseMaxHP
var baseMaxMP
onready var path = $BG/Stats

func _ready():
	pass

func SetStats(charname,HP,MP,MaxHP,MaxMP, row):
	path.get_child(0).text = charname
	path.get_child(1).text = "HP: " + str(HP) + "/" + str(MaxHP)
	path.get_child(2).text = "MP: " + str(MP) + "/" + str(MaxMP)
	
	baseMaxHP = MaxHP
	baseMaxMP = MaxMP
	
func UpdateStats(HP, MP):
	path.get_child(1).text = "HP: " + str(HP) + "/" + str(baseMaxHP)
	path.get_child(2).text = "MP: " + str(MP) + "/" + str(baseMaxMP)
