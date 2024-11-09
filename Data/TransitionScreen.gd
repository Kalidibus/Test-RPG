extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.visible = false
	
func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")

func battle_transition():
	color_rect.visible = true
	animation_player.play("flash_white")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_to_black":
			animation_player.play("fade_to_normal")
			on_transition_finished.emit()
	elif anim_name == "flash_white":
			animation_player.play("fade_to_normal")
			on_transition_finished.emit()
	elif anim_name == "fade_to_normal":
		color_rect.visible = false
