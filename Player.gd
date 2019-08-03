extends KinematicBody2D

var motion = Vector2()
var hp = 1.0

func _physics_process(delta):

	rotate_to_mouse()
	handle_motion()
	
	get_parent().find_node("LabelHP").text = 'HP: '+ str(hp)
	
func rotate_to_mouse():
	var mouse_poz = get_global_mouse_position()
	look_at(mouse_poz)
	
	# This is needed for some reason because the player is not facing the mouse otherwise
	rotate(3*PI/2) 
	
func handle_motion():
	motion.y = 0
	motion.x = 0
	
	if Input.is_action_pressed("ui_down"):
		motion.y = 100
	if Input.is_action_pressed("ui_up"):
		motion.y = -100
		hp -= 0.05
	if Input.is_action_pressed("ui_left"):
		motion.x = -100
	if Input.is_action_pressed("ui_right"):
		motion.x = 100
	
	motion = move_and_slide(motion)