extends ScrollContainer

@onready var scrollbar = get_v_scroll_bar()
var auto_scroll_speed : float = 0.1
var max_scroll_length = 0
var tween : Tween

func _ready():
	scrollbar.changed.connect(_range_changed)
	max_scroll_length = scrollbar.max_value

func _range_changed():
	if max_scroll_length != scrollbar.max_value:
		max_scroll_length = scrollbar.max_value
		tween = create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "scroll_vertical", max_scroll_length-get_rect().size.y, auto_scroll_speed)
