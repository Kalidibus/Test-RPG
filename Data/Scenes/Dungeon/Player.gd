extends Node3D

@onready var timerprocessor: = $Timer
@onready var forward: = $RayForward
@onready var back: = $RayBack
@onready var right: = $RayRight
@onready var left: = $RayLeft

#adjust this to change movement speed on map
@onready var spd: = Globals.PLAY_SPEED

var encounterRNG = 0
var num = RandomNumberGenerator.new()
var rng

#picks how many steps until next encounter each time the map is loaded
func _ready():
	num.randomize()
	rng = num.randi_range(20, 100)

#checks for collisions against walls 
func collision_check(direction):
	if direction != null:
		$AnimationPlayer.play("Step")
		return direction.is_colliding()
	else:
		return false

func get_direction(direction):
	if not direction is RayCast3D: return
	return direction.get_collider().global_transform.origin - global_transform.origin

#reads input and moves player accordingly
func _on_timer_timeout():
	var GO_W := Input.is_action_pressed("ui_up")
	var GO_S := Input.is_action_pressed("ui_down")
	var GO_A := Input.is_action_pressed("ui_left")
	var GO_D := Input.is_action_pressed("ui_right")
	var TURN_Q := Input.is_action_pressed("Turn_Left")
	var TURN_E := Input.is_action_pressed("Turn_Right")
	var Escape := Input.is_action_pressed("Escape")

	var ray_dir
	var turn_dir = int(TURN_Q) - int(TURN_E)


	if GO_W: 
		ray_dir = forward
	elif GO_S: 
		ray_dir = back
	elif GO_A: 
		ray_dir = left
	elif GO_D: 
		ray_dir = right
	elif Escape:
		Globals.mappos = position
		Globals.maprotation = rotation
		get_tree().change_scene_to_file("res://Scenes/Other/PauseMenu/PauseMenu.tscn")
	elif turn_dir:
		timerprocessor.stop()
		await tween_rotation(PI/2 * turn_dir)
		timerprocessor.start()

	if collision_check(ray_dir):
		timerprocessor.stop()
		await tween_translation(get_direction(ray_dir))
		timerprocessor.start()

#translates camera
func tween_translation(change):
	$AnimationPlayer.play("Step")
	var tween = create_tween()
	tween.tween_property(self, "position", position + change,spd)
	await tween.finished
	encounter_check()

#rotates camera
func tween_rotation(change):
	var tween = create_tween()
	tween.tween_property(self, "rotation", rotation + Vector3(0, change, 0),spd)
	await tween.finished

#checks if it's time for an encounter
func encounter_check():
	encounterRNG = encounterRNG + Globals.ENCOUNTER_RATE
	print(encounterRNG)
	
	
	if encounterRNG >= rng:
		encounterRNG = 0
		Globals.mappos = position
		Globals.maprotation = rotation
		get_tree().change_scene_to_file("res://Scenes/Battle Scenes/Combat.tscn")
