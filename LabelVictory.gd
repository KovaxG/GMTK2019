extends Label

func _ready():
	visible = false

func _on_AreaVictory_body_entered(body):
	visible = true
	get_parent().find_node('Backpack').visible = false