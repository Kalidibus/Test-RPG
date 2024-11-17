extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_save_button_pressed() -> void:
	SaveandLoad.ask_save()


func _on_load_button_pressed() -> void:
	SaveandLoad.load_file()
