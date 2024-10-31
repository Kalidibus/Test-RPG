extends Node

#Lines should always be a dictionary like [Speaker1 = ["line1", "etc"], Speaker2 = ["line1", "etc"]

var lines = {
  "None" = [
    "The stone crumbles like spent charcoal beneath your boots. As you walk through the first few steps, the fetid still air clings to you, sloughing off like layer after layer of dead skin.",
    "In the distance, there is a sound of lapping waves.",
    "Amidst the static in your brain, a purpose beckons. You have to find her. Everything rides on it.",
    "...",
    "Was there a town near here once?...\nI can't remember.",
    "...",
    "We have to keep moving."
  ]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
