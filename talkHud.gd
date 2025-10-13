extends Node2D


@onready var mouth: Sprite2D = $"../Mouth"



@onready var button: Button = $Button
@onready var text_edit: TextEdit = $TextEdit
@onready var text_to_talk: Node2D = $"../TextToTalk"


# [Time][1234] for text information the indication of time and amount
var msg: String
var msgTime: float
var result 
var cleaned_msg 
var time 

func _ready():
	button.pressed.connect(_on_button_pressed)
	msg = "ok les try again"
	

func _on_button_pressed() -> void:
	text_edit.text = msg
	$"../TextToTalk".text_to_speech(msg)
	$"../Mouth".doTalking(msg,$"../TextToTalk".totalDelay, $"../TextToTalk".talkTime)  # Pass a duration (e.g., 2 seconds)
	

	



func _on_line_edit_text_submitted(new_text: String) -> void:
	# msg = msg + "[Time]" + "[" + str(node_2d.talkTime) +"]"
	#result = parse_message(msg )
	#cleaned_msg = result[0]
	#time = result[1]
	#text_edit.text = cleaned_msg
	#mouth.doTalking(cleaned_msg, time)  # Pass a duration (e.g., 2 seconds)
	text_edit.text = msg
	$"../TextToTalk".text_to_speech(msg)
	$"../Mouth".doTalking(msg,$"../TextToTalk".totalDelay, $"../TextToTalk".talkTime)  # Pass



func parse_message(msg: String) -> Array:
	var pattern = r"\[Time\]\[(\d+(\.\d+)?)\]"
	var regex = RegEx.new()
	regex.compile(pattern)
	
	var result = regex.search(msg)
	
	if result:
		var time_value = float(result.get_string(1))  # Just the number
		var clean_msg = msg.replace(result.get_string(0), "").strip_edges()
		return [clean_msg, time_value]
	else:
		return [msg, null]


func _on_text_edit_text_changed(new_text: String) -> void:
		msg = new_text
