class_name WordsFile
extends Control

var file_manager = null
var path = null
var wordpair_count = 0
var changed = false
var focused_pair = null

@onready var wordpairs: VBoxContainer = $Wordpairs


func _ready():
	$Wordpairs.hide()

func insert_pair(new_word, nat_word, history:Array, idx:=-1):
	var pair = preload("res://words file/word_pair.tscn").instantiate()
	$Wordpairs.add_child(pair)
	$Wordpairs.move_child(pair, idx)
	pair.init(new_word, nat_word, history, path, self)
	wordpair_count = $Wordpairs.get_child_count()
	changed = true
	return pair

func get_pair(idx):
	return $Wordpairs.get_child(idx)
	
func _process(delta):
	var wps = $Wordpairs.get_children()
	for i in range(len(wps)):
		if wps[i].nat_word_line.has_focus() or wps[i].new_word_line.has_focus():
			focused_pair = wps[i]
			
			if Input.is_action_just_pressed("enter"):
				if Input.is_action_pressed("shift"):
					insert_pair("", "", [], i)
					$Wordpairs.get_child(i).new_word_line.grab_focus()
					focused_pair = $Wordpairs.get_child(i)
				else:
					insert_pair("", "", [], i+1)
					$Wordpairs.get_child(i+1).new_word_line.grab_focus()
					focused_pair = $Wordpairs.get_child(i+1)
				
					
			if Input.is_action_just_pressed("delete") and $Wordpairs.get_child(i).nat_word_line.text == "":
				$Wordpairs.get_child(i).delete()
				if i != 0:
					var pair =  $Wordpairs.get_child(i-1)
					pair.nat_word_line.grab_focus()
					pair.nat_word_line.caret_column = len(pair.nat_word_line.text)
					focused_pair = pair
					
		else:
			focused_pair = null
			
	$HBoxContainer/FileName.text = path.get_file().get_basename() + " | " + str(wordpair_count)
		


func _on_hide_button_pressed():
	$Wordpairs.visible = !$Wordpairs.visible

func _on_add_button_pressed():
	insert_pair("", "", [])
	$Wordpairs.visible = true
	changed = true


func _on_close_button_pressed():
	file_manager.file_closed(self)
	queue_free()
	
func pair_removed(pair):
	changed = true
	wordpair_count -= 1
