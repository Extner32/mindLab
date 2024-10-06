class_name WordsFile
extends Control

var file_manager = null
var path = ""
var wordpair_count = 0

func _ready():
	$VBoxContainer/HBoxContainer/FileName.text = path.get_file()

func add_pair(new_word, nat_word, history):
	var pair = preload("res://words file/word_pair.tscn").instantiate()
	pair.init(new_word, nat_word, history, path)
	$VBoxContainer/Wordpairs.add_child(pair)
	wordpair_count = $VBoxContainer/Wordpairs.get_child_count()

func get_pair(idx):
	$VBoxContainer/Wordpairs.get_child(idx)

func _on_button_pressed():
	queue_free()
