extends KinematicBody2D

var motion = Vector2()
var hp = 1.0

func _physics_process(delta):
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
	
	get_parent().find_node("LabelHP").text = 'HP: '+ str(hp)
	#print(labelHP)