extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Encounters():
	#simple for now. add RNG later.
	var enemies = {"e01" = {"name" = "pylon"}}
	return enemies 
