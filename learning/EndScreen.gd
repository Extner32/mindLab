extends VBoxContainer


signal closed(restart)

func show_results(total_words, correct_words, wrong_words):
	
	$RichTextLabel.text = ""
	
	var percent_correct = float(correct_words)/float(total_words) * 100.0
	percent_correct = snapped(percent_correct, 0.01)
	$Label2.text = str(percent_correct)+"%"
	
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
