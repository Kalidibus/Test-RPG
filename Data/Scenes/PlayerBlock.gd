extends HBoxContainer

func _ready():
	pass




func _on_Fortress_display_stats(charname, HP, MP, MaxHP, MaxMP):
	$Stats/Name.text = charname
	$Stats/Name.text = str(HP) + "/" + str(MaxHP)
	$Stats/Name.text = str(MP) + "/" + str(MaxMP)
