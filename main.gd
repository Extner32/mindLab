extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	await $FileManager.open_files()
	for file in $FileManager/OpenedFiles.get_children():
		file.debug_print()
		$VBoxContainer/Editor.add_words_file(file)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_open_file_button_pressed():
	await $FileManager.open_files()
	for file in $FileManager/OpenedFiles.get_children():
		file.debug_print()
		$VBoxContainer/Editor.add_words_file(file)
