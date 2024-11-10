extends Control
var tbd = preload("res://Assets/UI/Status/TBD-icon.png")
var regen = preload("res://Assets/UI/Status/regen.png")
var marked = preload("res://Assets/UI/Status/marked.png")

var poison = preload("res://Assets/UI/Status/poison.png")
var burn = preload("res://Assets/UI/Status/burn.png")
var stun = preload("res://Assets/UI/Status/stun.png")
var seal = preload("res://Assets/UI/Status/seal.png")
var blind = preload("res://Assets/UI/Status/blind.png")


func SetStatus(status, stattimer):
	match status: 
		"regen": $Sprite2D.set_texture(regen)
		"poison": $Sprite2D.set_texture(poison)
		"burn": $Sprite2D.set_texture(burn)
		"stun": $Sprite2D.set_texture(stun)
		"blind": $Sprite2D.set_texture(blind)
		"seal": $Sprite2D.set_texture(seal)
		"marked": $Sprite2D.set_texture(marked)
	
	$Sprite2D/Count.text = str(stattimer)
	scale = Vector2(0.2, 0.2)
