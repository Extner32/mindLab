extends Control

var wordpairs = []
var path = ""

func add_pair(nat_word="", new_word=""):
	var pair = preload("res://wordpair/word_pair.tscn").instantiate()
	pair.nat_word.text = nat_word
	pair.new_word.text = new_word
	$VBoxContainer.add_child(pair)
	
	return pair
