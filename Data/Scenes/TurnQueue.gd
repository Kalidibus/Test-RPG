extends Node
class_name TurnQueue

var active_character

func initialize():
	active_character = get_child(0)


# Determines whos turn it is based on the active_character. By default it's the first child item.
# Once the function play_turn completes on that character, it comes back here, and moves on to the next character. 
# GDQuest also has a tutorial on how to sort this by speed, but we'll do that later, this is functional enough for now. 

func play_turn():
	yield(active_character.play_turn(), "completed")
	var new_index : int = (active_character.get_index() + 1) % get_child_count()
	active_character = get_child(new_index)
