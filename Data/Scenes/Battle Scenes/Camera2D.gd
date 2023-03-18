extends Camera2D

@onready var shakeTimer = $Timer
@onready var tween = create_tween()

var shake_amount = 0
var default_offset = offset

func _ready():
	Globals.camera = self
	set_process(false)

func _process(delta): #causes shaking
	offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(shake_amount, -shake_amount)) * delta + default_offset

func shake(new_shake, shake_time = 0.4, shake_limit = 100): #starts shaking
	shake_amount += new_shake
	if shake_amount > shake_limit:
		shake_amount = shake_limit
	
	shakeTimer.wait_time = shake_time
	
	set_process(true)
	shakeTimer.start()
	
func _on_Timer_timeout(): #stops shaking
	shake_amount = 0
	set_process(false)
	
	create_tween().tween_property(self, "offset", default_offset,0.1)
