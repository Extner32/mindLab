extends VBoxContainer


signal closed

func show_results(correct_words, wrong_words):
	
	$RichTextLabel.text = ""
	var total_words = correct_words + wrong_words
	
	var percent_correct = float(correct_words)/float(total_words) * 100.0
	percent_correct = snapped(percent_correct, 0.01)
	$Label.text = str(percent_correct)+"%"
	
	$RichTextLabel.text += "[center]"
	
	$RichTextLabel.text += "[color="+UserSettings.correct_hex+"]"+"correct words: "+str(correct_words)+"[/color]"
	$RichTextLabel.text += "\n"
	$RichTextLabel.text += "[color="+UserSettings.wrong_hex+"]"+"wrong words: "+str(wrong_words)+"[/color]"
	$RichTextLabel.text += "\n"
	$RichTextLabel.text += "[color=9999ae]total words: "+str(total_words)+"[/color]"
	$RichTextLabel.text += "[/center]"
	
	show()




func _on_button_pressed() -> void:
	closed.emit()
	hide()
