extends Node2D

signal confirmation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_text(input_text):
	%popuptext.text = input_text

func focusOK():
		%Button.grab_focus()


func _on_button_pressed() -> void:
	emit_signal("confirmation")
