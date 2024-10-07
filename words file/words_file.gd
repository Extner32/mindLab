class_name WordsFile
extends Control

var file_manager = null
var path = null
var wordpair_count = 0

func _ready():
	$HBoxContainer/FileName.text = path.get_file()

func add_pair(new_word, nat_word, history):
	var pair = preload("res://words file/word_pair.tscn").instantiate()
	$Wordpairs.add_child(pair)
	pair.init(new_word, nat_word, history, path)
	wordpair_count = $Wordpairs.get_child_count()

func get_pair(idx):
	return $Wordpairs.get_child(idx)
	
func _process(delta):
	var wordpairs = $Wordpairs.get_children()
	for i in range(len(wordpairs)):
		if wordpairs[i].nat_word_line.has_focus():
			if Input.is_action_just_pressed("enter"):
				if i == (wordpair_count-1): 
					add_pair("", "", [])
					$Wordpairs.get_child(i+1).new_word_line.grab_focus()
				else: 
					$Wordpairs.get_child(i+1).new_word_line.grab_focus()
		
		


func _on_add_button_pressed():
	add_pair("", "", [])


func _on_close_button_pressed():
	file_manager.file_closed(self)
	queue_free()
	
