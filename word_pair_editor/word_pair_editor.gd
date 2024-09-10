extends Control

var all_wordpairs = []
var selected_pair = 0

func _process(delta):
	if len(all_wordpairs) == 0:
		$ScrollContainer/VBoxContainer/AddWordPairButton.hide()
	else:
		$ScrollContainer/VBoxContainer/AddWordPairButton.show()
		
		var children = $ScrollContainer/VBoxContainer/WordPairs.get_children()
		for i in range(len(children)):
			var child = children[i]
			if child.nat_word.has_focus() or child.new_word.has_focus():
				selected_pair = i
				break
				
		if Input.is_action_just_pressed("enter"):
			var new_pair = null
			if selected_pair == len(children)-1:
				new_pair = add_pair()
				new_pair.nat_word.grab_focus()
				
			else:
				new_pair = children[selected_pair+1]
				new_pair.nat_word.grab_focus()
				
			await get_tree().process_frame
			$ScrollContainer.ensure_control_visible(new_pair)

func add_words_file(words_file):
	all_wordpairs += words_file.wordpairs
	var children = $ScrollContainer/VBoxContainer/WordPairs.get_children()
	for child in children:
		child.queue_free()
	
	for wp in all_wordpairs:
		var pair = add_pair()
		pair.nat_word.text = wp.nat_word
		pair.new_word.text = wp.new_word

func add_pair():
	var pair = preload("res://wordpair/word_pair.tscn").instantiate()
	$ScrollContainer/VBoxContainer/WordPairs.add_child(pair)
	
	return pair


func _on_add_word_pair_button_pressed():
	add_pair()
