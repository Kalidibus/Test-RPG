extends Node

export var CharacterName = ""
export var MaxHP = 0
export var HP = 0
export var MaxMP = 0
export var MP = 0

signal HPUpdate
signal MPUpdate

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	CharacterName = "Kalidibus"
	MaxHP = 100
	HP = 100
	MaxMP = 100
	MP = 100
	
	emit_signal("HPUpdate")
	emit_signal("MPUpdate")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
