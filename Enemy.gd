extends KinematicBody2D

var motion = Vector2()

func _physics_process(delta):
	motion.x = rand_range(-100,100)
	motion.y = rand_range(-100,100)
	
	motion = move_and_slide(motion)
	pass