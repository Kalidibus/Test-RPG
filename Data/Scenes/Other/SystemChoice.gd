extends Node2D

signal confirmation
signal right_confirmation
var choice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_text(input_text):
	%popuptext.text = input_text

func set_buttons(left_button, right_button):
	%LeftButton.text = left_button
	%RightButton.text = right_button

func focusOK():
		%LeftButton.grab_focus()

func _on_left_button_pressed() -> void:
	choice = "left"
	emit_signal("confirmation")

func _on_right_button_pressed() -> void:
	choice = "right"
	emit_signal("confirmation")
