extends Control

func _on_open_file_button_pressed():
	await $FileManager.open_files()
	for file in $FileManager/OpenedFiles.get_children():
		$VBoxContainer/Editor.add_words_file(file)
		
	$VBoxContainer/Learning.combine_files($FileManager.opened_files)
