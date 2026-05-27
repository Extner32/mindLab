extends Control

@onready var file_manager = $MarginContainer/VBoxContainer/FileManager
@onready var learning = $MarginContainer/VBoxContainer/Learning

func _ready():
	# UserSettings.load_settings()
	$SaveTimer.wait_time = UserSettings.res.save_timer
	get_tree().auto_accept_quit = false
	for arg in OS.get_cmdline_args():
		if arg.get_extension() == "mLab":
			file_manager.open_file(arg)
	
	#if on android this is required to be able to access files
	if OS.has_feature("android"):
		OS.request_permissions()
		get_tree().root.content_scale_factor = 2.0
		$MarginContainer/VBoxContainer/HBoxContainer/StatusText.hide()
		
	$MarginContainer/VBoxContainer/HBoxContainer/SwitchModeButton.icon = preload("res://assets/images/Play.svg")
		
func _process(delta: float) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/StatusText.text = gb.status_text
	

func _on_file_manager_files_changed():
	print("files changed")
	file_manager.autosave()
	
func _on_file_manager_files_edited() -> void:
	print("files edited")
	file_manager.autosave()
	
	
func _on_new_file_button_pressed():
	await file_manager.new_file()

func _on_save_button_pressed():
	gb.status("[color="+UserSettings.correct_hex+"]saved[/color]")
	file_manager.save_all_files()
	UserSettings.save_settings()
	
func _on_open_file_button_pressed():
	await file_manager.open_files()
	learning.combine_files(file_manager.opened_files)


func _on_switch_mode_button_pressed():
	if file_manager.visible:
		print("file manager")
		file_manager.hide()
		learning.show()
		$MarginContainer/VBoxContainer/HBoxContainer/SwitchModeButton.text = "Files"
		$MarginContainer/VBoxContainer/HBoxContainer/SwitchModeButton.icon = preload("res://assets/images/Pause.svg")
		
	elif learning.visible:
		print("learning")
		learning.hide()
		file_manager.show()
		$MarginContainer/VBoxContainer/HBoxContainer/SwitchModeButton.text = "Learn"
		$MarginContainer/VBoxContainer/HBoxContainer/SwitchModeButton.icon = preload("res://assets/images/Play.svg")
		


func _on_save_timer_timeout():
	file_manager.autosave()
	UserSettings.save_settings()

#called when the application is closed
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		file_manager.autosave()
		get_tree().quit()
