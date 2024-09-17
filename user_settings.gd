extends Node

var word_pair_height = 15
var file_seperator = "@"


#false: new_word, natural_word
#true: natural_word, new_word
var reversed_direction = true

enum learn_modes {ONE_CYCLE, REPEAT}
var learn_mode = learn_modes.REPEAT
#one_cycle: go trough all words once
#repeat: repeat all words until all are done

var correct_color = Color(0.2, 0.741, 0.470)
var wrong_color = Color(0.670, 0.047, 0.325)
