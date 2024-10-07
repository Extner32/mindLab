class_name WordPair
extends Control

@onready var new_word_line = $NewWord
@onready var nat_word_line = $NatWord


var new_word: String
var nat_word: String
var history: Array
var origin_path: String

func init(_new_word, _nat_word, _history, _origin_path):
	new_word = _new_word
	nat_word = _nat_word
	history = _history
	origin_path = origin_path
	$NewWord.text = new_word
	$NatWord.text = nat_word
	
func debug_print():
	print(new_word, "@", nat_word, "@", history)
	
func _process(delta):
	new_word = new_word_line.text
	nat_word = nat_word_line.text
