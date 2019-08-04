extends KinematicBody2D

var motion = Vector2()

var V_PLAYER = 100
var control_type_relative = false
var K_debounced = true


	
func Lose(asd):
	$AudioDeath.play()
	while $AudioDeath.is_playing():
		HP=0
		motion = Vector2(0,0)
	get_tree().change_scene(current_level)

var deaththread = null


var HP = 1.0 setget set_hp
func set_hp(val):
	HP = val
	if HP<=0 and deaththread == null:
			deaththread=Thread.new()
			deaththread.start(self,"Lose")

var armor_coeff = 3


var left_holding = false
export(String, FILE, '*.tscn') var current_level

var textures = {'naked':load("res://GFX/g_prot.png"),
				'armored':load("res://GFX/a_prot.png"),
				'keret': load("res://GFX/keret.png"),
				'placeholer' : load('res://GFX/placeholder.png')}

var inventory = null
var item_names = ['ItemClub','ItemPotion','ItemArmor','ItemSpear']
var recently_picked_up = false

var throw_spear = false

func _ready():
	$Club.visible = false
	$Club/ClubArea.disabled = true
	$Spear.visible = false

func PickUpItem(overlaps):
	get_viewport_rect().position = Vector2(200,200)
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
				set_hp(HP * armor_coeff)
				V_PLAYER = 75
				$Sprite.texture = textures['armored']
			'ItemClub':
				$Club.visible = true
			'ItemSpear':
				$Spear.visible = true
			
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
			set_hp(HP/armor_coeff)
			V_PLAYER = 100
			$Sprite.texture = textures['naked']
		elif inventory.name == 'ItemClub':
			$Club.visible = false
		elif inventory.name == 'ItemSpear':
			$Spear.visible = false
			
		get_parent().find_node('IconItem').texture = null
		inventory = null

func UseItem():
	if inventory != null:
		match inventory.name:
			'ItemPotion':
				set_hp(1)
				destroy_item()
			'ItemClub':
				$Club/ClubArea.disabled = false
				$Club.rotate(0.3)
				if not $AudioClubWhoosh.playing:
					$AudioClubWhoosh.play()
			'ItemSpear':
				destroy_item()
				$Spear.visible = false
				var spear = preload("res://FlyingScene.tscn").instance()
				spear.start(global_position, rotation + PI/2)
				get_parent().add_child(spear)
		if inventory!=null and inventory.name != 'ItemClub' and $AudioClubWhoosh.playing:
			$AudioClubWhoosh.stop()

func destroy_item():
	inventory.position.x = -1000
	inventory.position.y = -1000
	get_parent().find_node('IconItem').texture = null
	inventory = null

func _physics_process(delta):
	$Club/ClubArea.disabled = true
	
	
	
	rotate_to_mouse()
	handle_motion()
		
	get_parent().find_node("LabelHP").text = 'HP: '+ str(HP)
	
func rotate_to_mouse():
	var mouse_poz = get_global_mouse_position()
	look_at(mouse_poz)
	
	# This is needed for some reason because the player is not facing the mouse otherwise
	rotate(3*PI/2) 
	
func handle_keyboard():
	if control_type_relative:
		if Input.is_key_pressed(KEY_S):
			motion.y = V_PLAYER * cos(rotation+PI)
			motion.x = -V_PLAYER * sin(rotation+PI)
		if Input.is_key_pressed(KEY_W):
			motion.y = V_PLAYER * cos(rotation)
			motion.x = -V_PLAYER * sin(rotation)
		if Input.is_key_pressed(KEY_A):
			motion.y = V_PLAYER * cos(rotation-PI/2)
			motion.x = -V_PLAYER * sin(rotation-PI/2)
		if Input.is_key_pressed(KEY_D):
			motion.y = V_PLAYER * cos(rotation+PI/2)
			motion.x = -V_PLAYER * sin(rotation+PI/2)
	else:
		if Input.is_key_pressed(KEY_S):
			motion.y = V_PLAYER
		if Input.is_key_pressed(KEY_W):
			motion.y = -V_PLAYER
		if Input.is_key_pressed(KEY_A):
			motion.x = -V_PLAYER
		if Input.is_key_pressed(KEY_D):
			motion.x = V_PLAYER
		if abs(motion.x) + abs(motion.y) == 2*V_PLAYER:
			motion.x /= sqrt(2)
			motion.y /= sqrt(2)
			
	if Input.is_key_pressed(KEY_K):
		if K_debounced:
			control_type_relative = not control_type_relative
			K_debounced = false
	else:
		K_debounced = true
		
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
func handle_motion():
	motion.y = 0
	motion.x = 0
	handle_keyboard()
	
	var overlaps = $Area2D.get_overlapping_areas()
	for area in overlaps:
		if 'Item' in area.name:
				PickUpItem(overlaps)	
		elif area.name == 'Weapon':
			set_hp(HP- 0.015)
			if inventory!=null and inventory.name == 'ItemArmor':
				if not $AudioClang.is_playing():
					$AudioClang.play()
			elif not $AudioStab.is_playing():
				$AudioStab.play()
				
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		UseItem()
		if not left_holding:
			left_holding = true
	else:
		left_holding = false
		$AudioClubWhoosh.stop()
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		DropItem()
		
	motion = move_and_slide(motion)
	
	get_parent().find_node("LabelHP").text = 'HP: '+ str(HP)
	
	