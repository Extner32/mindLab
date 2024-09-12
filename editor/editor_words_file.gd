extends Control

var file = null

func link_words_file(words_file):
	file = words_file
	for i in range(len(words_file.wordpairs)):
		add_pair(words_file.wordpairs[i].new_word, words_file.wordpairs[i].nat_word)


func add_pair(new_word="", nat_word=""):
	var pair = preload("res://editor/editor_word_pair.tscn").instantiate()
	$VBoxContainer/WordPairs.add_child(pair)
	pair.new_word.text = new_word
	pair.nat_word.text = nat_word
	
	return pair
