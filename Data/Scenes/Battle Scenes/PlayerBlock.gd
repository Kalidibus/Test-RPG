extends Control

var charid

var baseMaxHP
var baseMaxMP
var firstpos = false

var animated_HP = 0
var animated_MP = 0

func _ready():
	pass

func _process(delta):
	%HPBar.value = animated_HP
	%MPBar.value = animated_MP
	
func SetStats(name, HP,MP,MaxHP,MaxMP):
	%Name.text = name
	%HP.text = "HP: " + str(HP) + "/" + str(MaxHP)
	%MP.text = "MP: " + str(MP) + "/" + str(MaxMP)
	%HPBar.max_value = MaxHP
	%HPBar.value = HP
	%MPBar.max_value = MaxMP
	%MPBar.value = MP
	
	animated_HP = HP
	animated_MP = MP
	
	baseMaxHP = MaxHP
	baseMaxMP = MaxMP
	
func UpdateStats(HP, MP):
	%HP.text = "HP: " + str(HP) + "/" + str(baseMaxHP)
	%MP.text = "MP: " + str(MP) + "/" + str(baseMaxMP)

#func SetImage(string):
	#%BG.set_texture(load(string))

func SwitchRows(row):
	if row == Entity.row_line.FRONT:
		%Vanguardlabel.visible = true
		%Readguardlabel.visible = false
		if firstpos != true: 
			%BG.position = Vector2(0,-150)
			firstpos = true
		else:
			%BG.position = %BG.position + Vector2(0,-50)
	elif row == Entity.row_line.BACK:
		%Vanguardlabel.visible = false
		%Readguardlabel.visible = true
		if firstpos != true: 
			%BG.position = Vector2(0,-100)
			firstpos = true
		else:
			%BG.position = %BG.position + Vector2(0,+50)
