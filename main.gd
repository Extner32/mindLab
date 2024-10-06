extends Control

@onready var file_manager = $VBoxContainer/FileManager



func _on_open_file_button_pressed():
	await file_manager.open_files()
	$VBoxContainer/Learning.combine_files(file_manager.opened_files)



func _on_file_manager_files_changed():
	$VBoxContainer/Learning.combine_files(file_manager.opened_files)


func _on_save_button_pressed():
	file_manager.save_all_files()
