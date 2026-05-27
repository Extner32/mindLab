class_name UserSettingsRes
extends Resource

#basic settings
@export var save_timer: float = 3.0
@export var autosave: bool = true

#learn mode settings
@export var learn_modes: Array
@export var current_learn_mode: String
@export var reversed_direction: bool
@export var segment_size: int


#stats
@export var total_words_learned: int
