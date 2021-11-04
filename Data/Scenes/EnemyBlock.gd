extends HBoxContainer

func _ready():
	pass




func _on_monKobold_display_stats(charname,HP,MP,MaxHP,MaxMP, position):
	$Stats/Name.text = charname
	$Stats/HP.text = str(HP) + "/" + str(MaxHP)
	$Stats/MP.text = str(MP) + "/" + str(MaxMP)
	$Stats/Position.text = position


func _on_monKobold_HP_change(HP, MaxHP):
	$Stats/HP.text = str(HP) + "/" + str(MaxHP)
