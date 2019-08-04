extends Area2D

export(String, FILE, "*.tscn") var next_map

func _on_Ladder_body_entered(body):
	if body.name == 'Player':
		get_tree().change_scene(next_map)