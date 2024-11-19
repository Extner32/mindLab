class_name WordPair
extends Control

@onready var new_word_line = $NewWord
@onready var nat_word_line = $NatWord


var new_word: String
var nat_word: String
var history: Array
var origin_path: String
var words_file = null

func init(_new_word, _nat_word, _history, _origin_path, _words_file):
	new_word = _new_word
	nat_word = _nat_word
	history = _history
	origin_path = origin_path
	words_file = _words_file
	$NewWord.text = new_word
	$NatWord.text = nat_word
	
func debug_print():
	print(new_word, "@", nat_word, "@", history)
	
func _process(delta):
	new_word = new_word_line.text
	nat_word = nat_word_line.text
	
	if nat_word_line.has_focus() and nat_word_line.text == "" and Input.is_action_just_pressed("backspace"):
		new_word_line.grab_focus()
		
	if new_word_line.has_focus() and new_word_line.text == "" and Input.is_action_just_pressed("backspace"):
		delete()
	
	var rect = Rect2(global_position, size)
	$DeleteButton.visible = rect.has_point(get_global_mouse_position()) or new_word_line.has_focus() or nat_word_line.has_focus()
	

func _on_delete_button_pressed():
	delete()
	

func delete():
	words_file.pair_removed(self)
	queue_free()
