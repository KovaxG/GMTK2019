extends KinematicBody2D

var motion = Vector2()
var target = null
var speed = 100
var swing_left = true

func _physics_process(delta):
	motion.x = 0
	motion.y = 0
	
	if target == null:
		look_for_target()
	else:
		move_towards_target()
		
	motion = move_and_slide(motion)
	
	pass
	
func move_towards_target():
	var self_position = position
	look_at(target.position)
	rotate(3*PI/2) 
	motion.x = target.position.x - self_position.x
	motion.y = target.position.y - self_position.y
	swing_weapon()
	
	
func swing_weapon():
	if $Weapon.rotation <= -1:
		swing_left = false
	elif $Weapon.rotation >= 1:
		swing_left = true
		
	if not swing_left:
		$Weapon.rotate(0.1)	
	else:
		$Weapon.rotate(-0.1)
	
		
func look_for_target():
	if $RayCast2D.is_colliding():
		var object = $RayCast2D.get_collider()
		if object.name == "Player":
			target = object