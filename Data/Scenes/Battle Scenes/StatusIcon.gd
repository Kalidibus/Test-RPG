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
		Entity.status_effects.REGEN: $Sprite2D.set_texture(regen)
		Entity.status_effects.POISON: $Sprite2D.set_texture(poison)
		Entity.status_effects.BURN: $Sprite2D.set_texture(burn)
		Entity.status_effects.STUN: $Sprite2D.set_texture(stun)
		Entity.status_effects.BLIND: $Sprite2D.set_texture(blind)
		Entity.status_effects.SEAL: $Sprite2D.set_texture(seal)
		Entity.status_effects.MARKED: $Sprite2D.set_texture(marked)
	
	$Sprite2D/Count.text = str(stattimer)
	scale = Vector2(0.2, 0.2)
