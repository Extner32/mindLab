extends HBoxContainer

func _ready() -> void:
	update_icon()

func update_icon():
	if UserSettings.res.reversed_direction:
		$word1.text = "Natural Word"
		$word2.text = "New Word"
	else:
		$word1.text = "New Word"
		$word2.text = "Natural Word"

func _on_button_pressed() -> void:
	UserSettings.res.reversed_direction = !UserSettings.res.reversed_direction
	update_icon()
