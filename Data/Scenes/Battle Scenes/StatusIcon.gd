extends Control
var redicon = preload("res://Assets/StatusIcons/icon_small_red.png")
var greenicon = preload("res://Assets/StatusIcons/icon_small_green.png")
var icon = preload("res://Assets/StatusIcons/icon_small.png")

func SetStatus(status, stattimer):
	if status == "regen":
			$Sprite2D.set_texture(greenicon)
	elif status == "poison" or "burn" or "stun" or "blind" or "seal" or "marked":
			$Sprite2D.set_texture(redicon)
	else:
			$Sprite2D.set_texture(icon)
	
	$Sprite2D/Count.text = str(stattimer)
	
