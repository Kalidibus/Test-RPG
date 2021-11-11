extends HBoxContainer

func _ready():
	pass

func SetStats(charname,HP,MP,MaxHP,MaxMP, row):
	$Stats/Name.text = charname
	$Stats/HPbar.max_value = MaxHP
	$Stats/HPbar.value = HP
	$Stats/MPbar.max_value = MaxMP
	$Stats/MPbar.value = MP
	$Stats/Position.text = row
	
	if row == "Front":
		$Sprite.set_offset(Vector2(20,80))

func UpdateStats(HP, MP):
	$Stats/HPbar.value = HP
	$Stats/HPbar.value = MP
