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
	var editor_words_file = preload("res://editor/editor_words_file.tscn").instantiate()
	$ScrollContainer/EditorWordsFiles.add_child(editor_words_file)
	editor_words_file.link_words_file(words_file)
	
	
	return editor_words_file
