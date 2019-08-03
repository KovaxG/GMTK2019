extends KinematicBody2D

var motion = Vector2()
var target = null
var speed = 100
var swing_left = true

var hp = 1
var alerted = false

func _physics_process(delta):
	
	if hp < 0:
		hide()
		$Weapon/weaponshape.disabled = true
		$Area2D/CollisionShape2D.disabled = true
		$CollisionShape2D2.disabled = true
		return
	
	motion.x = 0
	motion.y = 0
	
	if target == null:
		look_for_target()
		if alerted:
			rotate(0.1)
	else:
		move_towards_target()
		
	var objects = $Area2D.get_overlapping_areas()
	for object in objects:
		if object.name == 'Club':
			hp -= 0.1
			alerted = true
		
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