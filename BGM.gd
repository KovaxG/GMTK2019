extends AudioStreamPlayer

export(String, FILE, '*.ogg') var stream_name

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = load(stream_name)
	play()

