extends HBoxContainer

@onready var path = $BG/Stats
@onready var HPbar = $BG/Stats/HPbar

var animated_HP = 0
var animated_MP = 0

func _ready():
	pass

func _process(delta):
	HPbar.value = animated_HP

func SetStats(charname,HP,MP,MaxHP,MaxMP, row, image):
	%Name.text = charname
	%HPbar.max_value = MaxHP
	%HPbar.value = HP
	
	animated_HP = HP
	animated_MP = MP
	
	$Sprite2D.texture = load(image)
	
	if row == Entity.row_line.FRONT:
		$Sprite2D.set_offset(Vector2(0,25))
		var current_scale = $Sprite2D.get_scale()
		var new_scale: Vector2
		new_scale.x = current_scale.x * 1.4
		new_scale.y = current_scale.y * 1.4
		$Sprite2D.set_scale(new_scale)
		$Sprite2D.set_z_index(-2)
	if row == Entity.row_line.BACK: 
		z_index -= 10
