extends Node2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var armor = preload("res://Armor.tscn").instance()
	armor.position = Vector2(100,100)
	get_parent().add_child(armor)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
