extends HBoxContainer

@onready var path = $BG/Stats
@onready var HPbar = $BG/Stats/HPbar

var animated_HP = 0
var animated_MP = 0

func _ready():
	pass

func _process(delta):
	HPbar.value = animated_HP

func SetStats(charname,HP,MP,MaxHP,MaxMP, row):
	%Name.text = charname
	%HPbar.max_value = MaxHP
	%HPbar.value = HP
	
	animated_HP = HP
	animated_MP = MP
	
	if row == "Front":
		$Sprite2D.set_offset(Vector2(0,25))
		$Sprite2D.set_scale(Vector2(8,8))
		$Sprite2D.set_z_index(-2)
