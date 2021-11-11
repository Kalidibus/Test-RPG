extends HBoxContainer

var baseMaxHP
var baseMaxMP

func _ready():
	pass

func SetStats(charname,HP,MP,MaxHP,MaxMP, row):
	$Stats/Name.text = charname
	$Stats/HP.text = str(HP) + "/" + str(MaxHP)
	$Stats/MP.text = str(MP) + "/" + str(MaxMP)
	$Stats/Position.text = row
	
	baseMaxHP = MaxHP
	baseMaxMP = MaxMP

func UpdateStats(HP, MP):
	$Stats/HP.text = str(HP) + "/" + str(baseMaxHP)
	$Stats/MP.text = str(MP) + "/" + str(baseMaxMP)
