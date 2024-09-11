extends Control

#func _process(delta):
		#var children = $ScrollContainer/VBoxContainer/WordPairs.get_children()
		#for i in range(len(children)):
			#var child = children[i]
			#if child.nat_word.has_focus() or child.new_word.has_focus():
				#selected_pair = i
				#break
				#
		#if Input.is_action_just_pressed("enter"):
			#var new_pair = null
			#if selected_pair == len(children)-1:
				#new_pair = add_pair()
				#new_pair.nat_word.grab_focus()
				#
			#else:
				#new_pair = children[selected_pair+1]
				#new_pair.nat_word.grab_focus()
				#
			#await get_tree().process_frame
			#$ScrollContainer.ensure_control_visible(new_pair)


func add_words_file(words_file):
	var file = preload("res://word_pair_editor/editor_words_file.tscn").instantiate()
	file.path = words_file.path
	for i in range(len(words_file.wordpairs)):
		file.wordpairs.append(words_file.wordpairs[i])
		var wp = file.add_pair(words_file.wordpairs[i].nat_word, words_file.wordpairs[i].new_word)
	$ScrollContainer/VBoxContainer.add_child(file)

func add_pair():
	var pair = preload("res://wordpair/word_pair.tscn").instantiate()
	$ScrollContainer/VBoxContainer/WordPairs.add_child(pair)
	
	return pair
