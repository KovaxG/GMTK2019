extends Area2D

func _on(body):
	if body.name == 'Player':
		get_tree().change_scene(next_map)
