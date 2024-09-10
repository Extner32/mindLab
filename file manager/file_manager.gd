class_name FileManager
extends Node

var open_files_path = []

func _ready():
	$FileDialog.hide()

func open_file():
	$FileDialog.file_mode = 1
	$FileDialog.current_dir = "/"
	$FileDialog.show()
	get_tree().paused = true
	await $FileDialog.files_selected
	get_tree().paused = false
	return open_files_path
	
	
	
func _on_file_dialog_files_selected(paths):
	open_files_path = paths
