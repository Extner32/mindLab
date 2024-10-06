class_name WordPair
extends Control

var new_word: String
var nat_word: String
var history: Array
var origin_path: String

func init(_new_word, _nat_word, _history, _origin_path):
	new_word = _new_word
	nat_word = _nat_word
	history = _history
	origin_path = origin_path
	
func debug_print():
	print(new_word, "@", nat_word, "@", history)
