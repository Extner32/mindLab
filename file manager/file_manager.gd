class_name FileManager
extends Control

var open_files_path = []
var save_file_path = ""

var opened_files_names = []

#used to store where the user last opened a file
var last_opened_dir = "/"

@onready var opened_files = $ScrollContainer/OpenedFiles

signal files_changed

func _ready():
	$OpenFileDialog.hide()
	$SaveFileDialog.hide()
	
func check_files_changed():
	var changed = false
	for wordfile in opened_files.get_children():
		if wordfile.changed == true:
			changed = true
			wordfile.changed = false
	
	if changed:
		files_changed.emit()
	
	return changed
	
func open_filedialog():
	if not FileAccess.file_exists(UserSettings.get_file_path()):
		var settings = FileAccess.open(UserSettings.get_file_path(), FileAccess.WRITE)
		settings.store_string(last_opened_dir)
		settings.close()
		
	var settings = FileAccess.open(UserSettings.get_file_path(), FileAccess.READ)
	var lines = settings.get_as_text(true)
	lines.split("\n")
	last_opened_dir = lines[0]
	
	$OpenFileDialog.file_mode = 1
	$OpenFileDialog.current_dir = last_opened_dir
	$OpenFileDialog.show()
		
	get_tree().paused = true
	await $OpenFileDialog.files_selected
	get_tree().paused = false
	return open_files_path

func save_filedialog():
	$SaveFileDialog.current_dir = last_opened_dir
	$SaveFileDialog.show()
		
	get_tree().paused = true
	await $SaveFileDialog.file_selected
	get_tree().paused = false
	return save_file_path

func _on_open_file_dialog_files_selected(paths):
	open_files_path = paths
	
func _on_save_file_dialog_file_selected(path):
	save_file_path = path
	
#having to fix the crappy file dialog 
func _on_open_file_dialog_canceled():
	$OpenFileDialog.emit_signal("files_selected", [])
	
func _on_save_file_dialog_canceled():
	$SaveFileDialog.emit_signal("file_selected", "")
	

func new_file():
	await save_filedialog()
	if save_file_path == "":
		return
	var wordsfile = preload("res://words file/words_file.tscn").instantiate()
	wordsfile.path = save_file_path
	opened_files.add_child(wordsfile)
	
	wordsfile.file_manager = self
	
	
	opened_files_names.append(wordsfile.path)
	
	save_file(wordsfile)
	last_opened_dir = save_file_path
	files_changed.emit()

func open_file(filepath):
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
		
		file.add_pair(line[0], line[1], history)
		
	file.file_manager = self
	file.path = filepath
	
	opened_files_names.append(file.path)
	opened_files.add_child(file)
	files_changed.emit()
			
	return file
	
func save_file(words_file: WordsFile):
	
	var file = FileAccess.open(words_file.path, FileAccess.WRITE)

	for i in range(words_file.wordpair_count):
		var line = words_file.get_pair(i)
		#skip if no words have been entered
		if line.new_word == "" and line.nat_word == "":
			continue
		var history_string = ""
		for bit in line.history:
			if bit == true:
				history_string += "1"
			elif bit == false:
				history_string += "0"
		file.store_csv_line(PackedStringArray([line.new_word, line.nat_word, history_string]), UserSettings.file_seperator)
	
	file.close()


func save_all_files():
	for file in opened_files.get_children():
		save_file(file)

func autosave():
	if UserSettings.autosave:
		save_all_files()

func open_files():
	var filepaths = await open_filedialog()
		
	for filepath in filepaths:
		if filepath in opened_files_names:
			$FileOpenedDialog.show()
		else:
			open_file(filepath)
			last_opened_dir = filepath
			
	var settings = FileAccess.open(UserSettings.get_file_path(), FileAccess.WRITE)
	settings.store_string(last_opened_dir)


func file_closed(file):
	opened_files_names.erase(file.path)
	files_changed.emit()





