extends Control


func SetStatus(status, stattimer):
	if status == "poison" or "burn" or "stun" or "blind" or "seal" or "marked":
			$Sprite.set_texture(load("res://Assets/StatusIcons/icon_small_red.png"))
	if status == "regen":
			$Sprite.set_texture(load("res://Assets/StatusIcons/icon_small_green.png"))
	else:
			$Sprite.set_texture(load("res://Assets/StatusIcons/icon_small.png"))
	
	$Sprite/Count.text = str(stattimer)
	
