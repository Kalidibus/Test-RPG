extends HBoxContainer

export var CharacterName = ""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	$Stats/Name.text = str("Lephantis")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_HPUpdate():
#	$Stats/HP.text 
