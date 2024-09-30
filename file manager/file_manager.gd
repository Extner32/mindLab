class_name FileManager
extends Control

var open_files_path = []
var opened_files_names = []

#used to store where the user last opened a file
var last_file_path = "/"

@onready var opened_files = $ScrollContainer/OpenedFiles

signal files_changed

func _ready():
	$FileDialog.hide()
	
	

func open_filedialog():
	$FileDialog.file_mode = 1
	$FileDialog.current_dir = "/"
	$FileDialog.show()
		
	get_tree().paused = true
	await $FileDialog.files_selected
	get_tree().paused = false
	return open_files_path
	
func _on_file_dialog_files_selected(paths):
	open_files_path = paths
	
	

func read_file(filepath):
	var data = FileAccess.open(filepath, FileAccess.READ)
	var file = preload("res://words file/words_file.tscn").instantiate()
	while data.get_position() < data.get_length():
		var line = data.get_csv_line(UserSettings.file_seperator)
		var history = []
		for bit in line[2]:
			if bit == "0":
				history.append(false)
			elif bit == "1":
				history.append(true)
				
		file.wordpairs.append(file.WordPair.new(line[0], line[1], history, filepath))
		file.path = filepath
		file.file_manager = self
			
	return file
	
func open_files():
	var filepaths = await open_filedialog()
	
	opened_files_names.clear()
	for file in opened_files.get_children():
		opened_files_names.append(file.path.get_file())
		
	for filepath in filepaths:
		if filepath.get_file() in opened_files_names:
			$FileOpenedDialog.show()
		else:
			print("huh")
			opened_files.add_child(read_file(filepath))
			last_file_path = filepath
	
	#.get_base_dir()
	var pathfile = FileAccess.open(OS.get_executable_path(), FileAccess.WRITE)
	pathfile.store_string(last_file_path)


#gets emitted when a file gets closed
func _on_opened_files_child_exiting_tree(node):
	await get_tree().create_timer(0.01).timeout
	files_changed.emit()
