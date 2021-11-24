extends Control

var baseMaxHP
var baseMaxMP
onready var path = $BG/Stats
onready var HPbar = $BG/Stats/HPBar
onready var MPbar = $BG/Stats/MPBar

var animated_HP = 0
var animated_MP = 0

func _ready():
	pass

func _process(delta):
	HPbar.value = animated_HP
	MPbar.value = animated_MP
	
func SetStats(charname,HP,MP,MaxHP,MaxMP, row):
	path.get_child(0).text = charname
	path.get_child(1).text = "HP: " + str(HP) + "/" + str(MaxHP)
	path.get_child(2).text = "MP: " + str(MP) + "/" + str(MaxMP)
	path.get_child(3).max_value = MaxHP
	path.get_child(3).value = HP
	path.get_child(4).max_value = MaxMP
	path.get_child(4).value = MP

	animated_HP = HP
	animated_MP = MP
	
	
	baseMaxHP = MaxHP
	baseMaxMP = MaxMP
	
func UpdateStats(HP, MP):
	path.get_child(1).text = "HP: " + str(HP) + "/" + str(baseMaxHP)
	path.get_child(2).text = "MP: " + str(MP) + "/" + str(baseMaxMP)
	#path.get_child(3).value = HP
	#path.get_child(4).value = MP

func SetImage(string):
	print(string)
	$BG/TextureRect.set_texture(load(string))
