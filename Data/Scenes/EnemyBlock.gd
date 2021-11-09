extends HBoxContainer

func _ready():
	pass

func SetStats(charname,HP,MP,MaxHP,MaxMP, row):
	$Stats/Name.text = charname
	$Stats/HPbar.max_value = MaxHP
	$Stats/HPbar.value = HP
	$Stats/MP.text = str(MP) + "/" + str(MaxMP)
	$Stats/Position.text = row
