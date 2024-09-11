extends HBoxContainer

@onready var new_word = $new_word
@onready var nat_word = $natural_word



# Called when the node enters the scene tree for the first time.
func _ready():
	new_word.custom_minimum_size.y = UserSettings.word_pair_height
	nat_word.custom_minimum_size.y = UserSettings.word_pair_height
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if nat_word.has_focus():
		if len(nat_word.text) == 0 and Input.is_action_just_pressed("backspace"):
			new_word.grab_focus()
