extends HBoxContainer

func _ready():
	pass

func SetStats(charname,HP,MP,MaxHP,MaxMP, row):
	$Stats/Name.text = charname
	$Stats/HP.text = str(HP) + "/" + str(MaxHP)
	$Stats/MP.text = str(MP) + "/" + str(MaxMP)
	$Stats/Position.text = row
