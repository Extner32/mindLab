extends Control

func _on_open_file_button_pressed():
	await $FileManager.open_files()
	for file in $FileManager/OpenedFiles.get_children():
		$VBoxContainer/Editor.add_words_file(file)
