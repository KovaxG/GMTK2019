extends Node2D


export(String) var contents
export(String,FILE,'*.tscn') var next_scene

var mouse_debounced = 0

func _ready():
	pass
	
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if mouse_debounced:
			get_tree().change_scene(next_scene)
	else:
		mouse_debounced = true