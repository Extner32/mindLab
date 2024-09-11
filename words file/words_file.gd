extends Node

var wordpairs = []
var path = ""


class WordPair:
	var new_word: String
	var nat_word: String
	var history: Array
	
	func _init(_new_word, _nat_word, _history):
		new_word = _new_word
		nat_word = _nat_word
		history = _history
		
	func debug_print():
		print(new_word, "@", nat_word, "@", history)

		
func debug_print():
	print(path)
	for wp in wordpairs:
		wp.debug_print()
