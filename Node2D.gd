extends Node2D


export(String) var contents
export(String,FILE,'*.txt') var contents_from_file
export(String,FILE,'*.tscn') var next_scene

var mouse_debounced = 0

func read_all_lines(filename):
    var file = File.new()
    file.open(filename, File.READ)
    var content = file.get_as_text()
    file.close()
    return content

func _ready():
	if contents == null or len(contents)<2:
		$RichTextContents.text = read_all_lines(contents_from_file)
	else:
		$RichTextContents.text = contents
	
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if mouse_debounced:
			get_tree().change_scene(next_scene)
	else:
		mouse_debounced = true