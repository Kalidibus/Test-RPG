extends HBoxContainer

onready var path = $BG/Stats

func _ready():
	pass

func SetStats(charname,HP,MP,MaxHP,MaxMP, row):
	path.get_child(0).text = charname
	path.get_child(1).max_value = MaxHP
	path.get_child(1).value = HP
	path.get_child(2).max_value = MaxMP
	path.get_child(2).value = MP
	
	if row == "Front":
		$Sprite.set_offset(Vector2(20,80))

func UpdateStats(HP, MP):
	path.get_child(1).value = HP
	path.get_child(2).value = MP
