extends VBoxContainer

@onready var learning = $".."

signal closed(restart)

func show_results():
	$RichTextLabel.text = ""
	
	var percent_correct = float(learning.correct_words)/float(len(learning.all_wordpairs)) * 100.0
	percent_correct = snapped(percent_correct, 0.01)
	
	$RichTextLabel.text += "[b]"+"percent correct: "+str(percent_correct)+"%"+"[/b]"
	$RichTextLabel.text += "\n"
	
	$RichTextLabel.text += "[color="+UserSettings.correct_color.to_html()+"]"+"correct words: "+str(learning.correct_words)+"[/color]"
	$RichTextLabel.text += "\n"
	
	$RichTextLabel.text += "[color="+UserSettings.wrong_color.to_html()+"]"+"wrong words: "+str(learning.wrong_words)+"[/color]"
	show()


func _on_ok_button_pressed():
	hide()
	closed.emit(false)

func _on_redo_button_pressed():
	hide()
	closed.emit(true)
