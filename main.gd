extends Control

func _on_open_file_button_pressed():
	await $VBoxContainer/HBoxContainer/FileManager.open_files()
	for file in $VBoxContainer/HBoxContainer/FileManager.opened_files.get_children():
		$VBoxContainer/Editor.add_words_file(file)
		
	$VBoxContainer/Learning.combine_files($VBoxContainer/HBoxContainer/FileManager.opened_files)
