extends VBoxContainer


signal closed(restart)

func show_results(all_wordpairs, correct_words, wrong_words):
	$RichTextLabel.text = ""
	
	var percent_correct = float(correct_words)/float(len(all_wordpairs)) * 100.0
	percent_correct = snapped(percent_correct, 0.01)
	
	$RichTextLabel.text += "[b]"+"percent correct: "+str(percent_correct)+"%"+"[/b]"
	$RichTextLabel.text += "\n"
	
	$RichTextLabel.text += "[color="+UserSettings.correct_color.to_html()+"]"+"correct words: "+str(correct_words)+"[/color]"
	$RichTextLabel.text += "\n"
	
	$RichTextLabel.text += "[color="+UserSettings.wrong_color.to_html()+"]"+"wrong words: "+str(wrong_words)+"[/color]"
	show()


func _on_ok_button_pressed():
	hide()
	closed.emit(false)

func _on_redo_button_pressed():
	hide()
	closed.emit(true)
