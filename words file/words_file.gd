extends Node

var wordpairs = []
var path = ""


class WordPair:
	var nat_word: String
	var new_word: String
	var history: Array
	
	func _init(_nat_word, _new_word, _history):
		nat_word = _nat_word
		new_word = _new_word
		history = _history
		
	func debug_print():
		print(nat_word, "@", new_word, "@", history)

		
func debug_print():
	print(path)
	for wp in wordpairs:
		wp.debug_print()
