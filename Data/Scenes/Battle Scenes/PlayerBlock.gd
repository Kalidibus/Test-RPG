extends Control

var baseMaxHP
var baseMaxMP
@onready var path = $BG/Stats
@onready var HPbar = $BG/Stats/HPBar
@onready var MPbar = $BG/Stats/MPBar
var firstpos = false

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
	
	#not currently working
	#if HP == 0: $BG.set_self_modulate("4c4c4c")
	#if HP != 0: $BG.set_self_modulate("ffffff")

func SetImage(string):
	$BG.set_texture(load(string))

func SwitchRows(active_character):
	if active_character.row == "Front":
		$BG/Vanguardlabel.visible = true
		$BG/Readguardlabel.visible = false
		if firstpos != true: 
			$BG.position = Vector2(0,-150)
			firstpos = true
		else:
			$BG.position = $BG.position + Vector2(0,-50)
	elif active_character.row == "Back":
		$BG/Vanguardlabel.visible = false
		$BG/Readguardlabel.visible = true
		if firstpos != true: 
			$BG.position = Vector2(0,-100)
			firstpos = true
		else:
			$BG.position = $BG.position + Vector2(0,+50)
