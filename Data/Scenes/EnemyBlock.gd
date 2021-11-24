extends HBoxContainer

onready var path = $BG/Stats
onready var HPbar = $BG/Stats/HPbar

var animated_HP = 0
var animated_MP = 0

func _ready():
	pass

func _process(delta):
	HPbar.value = animated_HP

func SetStats(charname,HP,MP,MaxHP,MaxMP, row):
	path.get_child(0).text = charname
	path.get_child(1).max_value = MaxHP
	path.get_child(1).value = HP
	
	animated_HP = HP
	animated_MP = MP
	
	if row == "Front":
		$Sprite.set_offset(Vector2(20,80))

func UpdateStats(HP, MP):
	pass #now handled by the GUI controller Tweening.
