extends Control
var redicon = preload("res://Assets/StatusIcons/icon_small_red.png")
var greenicon = preload("res://Assets/StatusIcons/icon_small_green.png")
var icon = preload("res://Assets/StatusIcons/icon_small.png")

func SetStatus(status, stattimer):
	if status == "regen":
			$Sprite.set_texture(greenicon)
	elif status == "poison" or "burn" or "stun" or "blind" or "seal" or "marked":
			$Sprite.set_texture(redicon)
	else:
			$Sprite.set_texture(icon)
	
	$Sprite/Count.text = str(stattimer)
	
