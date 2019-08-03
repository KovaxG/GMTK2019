extends KinematicBody2D

var motion = Vector2()
var hp = 1.0
var left_holding = false
var current_level = 1

var textures = {'naked':load("res://GFX/g_prot.png"),
				'armored':load("res://GFX/a_prot.png"),
				'keret': load("res://GFX/keret.png"),
				'placeholer' : load('res://GFX/placeholder.png')}

var inventory = null
var item_names = ['ItemClub','ItemPotion','ItemArmor','ItemSpear']
var recently_picked_up = false

func PickUpItem(overlaps):
	var item = null
	for area in overlaps:			
		if area.name in item_names and inventory == null:
			item = area
			break
	if item == null:
			recently_picked_up = false
			return
	else:
		match item.name:
			'ItemArmor':
				hp *= 2.0
				$Sprite.texture = textures['armored']
			
	inventory = item
	#item.visible = false
	item.position.x = -1000
	item.position.y = -1000
	get_parent().find_node('IconItem').texture = item.find_node('Texture').texture
	#get_parent().find_node('IconItem').update()
	
func DropItem():
	if inventory != null and not $HandsReach.get_overlapping_areas() and not $HandsReach.get_overlapping_bodies():
		inventory.position.x = position.x - 33 * sin(rotation) 
		inventory.position.y = position.y + 33 * cos(rotation)
		inventory.rotation = rotation+PI
		recently_picked_up = true
		
		if inventory.name == 'ItemArmor':
			hp/=2.0
			$Sprite.texture = textures['naked']
		get_parent().find_node('IconItem').texture = null
		inventory = null

func UseItem():
	if inventory != null:
		match inventory.name:
			'ItemPotion':
				hp=1
				inventory.position.x = -1000
				inventory.position.y = -1000
				get_parent().find_node('IconItem').texture = null
				inventory=null
				

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
	if Input.is_action_pressed("ui_left"):
		motion.x = -100
	if Input.is_action_pressed("ui_right"):
		motion.x = 100
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	var overlaps = $Area2D.get_overlapping_areas()
	for area in overlaps:
		if 'Item' in area.name:
				PickUpItem(overlaps)	
		elif area.name == 'Weapon':
			hp -= 0.015
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		UseItem()
		if not left_holding:
			left_holding = true
	else:
		left_holding = false
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		DropItem()
		
	motion = move_and_slide(motion)
	
	get_parent().find_node("LabelHP").text = 'HP: '+ str(hp)
	
	
func CompleteLevel():
	current_level += 1
	get_tree().change_scene('Level' + str(current_level) + '.tscn')
	

func _on_Ladder_body_entered(body):
	if body.name == 'Player':
		CompleteLevel()
