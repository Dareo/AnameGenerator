extends Node2D


@onready var line_edit: LineEdit = $LineEdit
@onready var text_edit: TextEdit = $TextEdit
@onready var button: Button = $Button
@onready var character: Node2D = $"../Character"
@onready var mouth = $"../Character/mouth"  # No need to type as Sprite2D

# [Time][1234] for text information the indication of time and amount
var msg: String
var msgTime: float
var result 
var cleaned_msg 
var time 
var tts_node
func _ready():
	button.pressed.connect(_on_button_pressed)
	tts_node = get_node("/root/Main/TTSNode") 

func _on_button_pressed() -> void:
	text_edit.text = msg
	$"../TTSNode".text_to_speech(msg)
	$"../Character/mouth".doTalking(msg,$"../TTSNode".totalDelay, $"../TTSNode".talkTime)  # Pass a duration (e.g., 2 seconds)
	

func _on_line_edit_text_changed(new_text: String) -> void:
	msg = new_text

func _on_line_edit_text_submitted(new_text: String) -> void:
	# msg = msg + "[Time]" + "[" + str(node_2d.talkTime) +"]"
	#result = parse_message(msg )
	#cleaned_msg = result[0]
	#time = result[1]
	#text_edit.text = cleaned_msg
	#mouth.doTalking(cleaned_msg, time)  # Pass a duration (e.g., 2 seconds)
	text_edit.text = msg
	$"../TTSNode".text_to_speech(msg)
	$"../Character/mouth".doTalking(msg,$"../TTSNode".totalDelay, $"../TTSNode".talkTime)  # Pass



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
