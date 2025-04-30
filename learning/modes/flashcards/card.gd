extends Control

var wordpair:WordPair = WordPair.new()

var side := false
var mouse_overlap := false
var velocity := Vector2.ZERO

const MAX_CLICK_TIME = 0.2
var click_timer = 0

#card doesn't move for LOCK_TIME amount of seconds after flip
#(to prevent card from drifting when you flip it)
var LOCK_TIME = 0.2
const LOCK_TIME_ANDROID = 0.7

var lock_timer = 0





@onready var animplayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if OS.has_feature("android"):
		LOCK_TIME = LOCK_TIME_ANDROID
	
func side_change(): #gets called from the animation
	side = !side

func _process(delta: float) -> void:
	
	
	pivot_offset = size/2.0
	#print(mouse_overlap)
	
	if side == false: 
		self.text = get_question()
	if side == true:
		self.text = get_correct_answer()
		
	if mouse_overlap and Input.is_action_just_pressed("LMB"):
		click_timer = MAX_CLICK_TIME
		
		
	if Input.is_action_just_released("LMB") and click_timer > 0:
		animplayer.play("flip")
		velocity = Vector2.ZERO
		
		lock_timer = LOCK_TIME
		click_timer = 0
	
	
	if click_timer <= 0:
		click_timer = 0
	else:
		click_timer -= delta
		
	if lock_timer <= 0:
		lock_timer = 0
	else:
		lock_timer -= delta
	
	if not lock_timer > 0:
		global_position += velocity * delta
	else:
		velocity = Vector2.ZERO


func get_question():
	# natural word -> new word
	if UserSettings.dict["reversed_direction"]:
		return wordpair.nat_word
	# new word -> natural word
	else:
		return wordpair.new_word

func get_correct_answer():
	# natural word -> new word
	if UserSettings.dict["reversed_direction"]:
		return wordpair.new_word
	# new word -> natural word
	else:
		return wordpair.nat_word



func _on_mouse_entered() -> void:
	mouse_overlap = true
func _on_mouse_exited() -> void:
	mouse_overlap = false
