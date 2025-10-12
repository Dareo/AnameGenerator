extends Node

@onready var http_request := $HTTPRequestElevenLabs
var api_key = "sk_e2cb7b90f307c6afb038220d9ce027f7ef2ac34a48386acf"
var voice_id = "EXAVITQu4vr4xnSDxMaL"

func _ready():
	text_to_speech("Welcome to my Godot game!")

func text_to_speech(text: String):
	var url = "https://api.elevenlabs.io/v1/text-to-speech/%s" % voice_id
	var headers = [
		"Content-Type: application/json",
		"xi-api-key: %s" % api_key
	]
	var body = {
		"text": text,
		"model_id": "eleven_monolingual_v1",
		"voice_settings": {
			"stability": 0.5,
			"similarity_boost": 0.75
		}
	}

	var json_body = JSON.stringify(body)
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if error != OK:
		print("Request error: ", error)

func _on_HTTPRequestElevenLabs_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var file_path = "user://tts_audio.mp3"
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		file.store_buffer(body)
		file.close()

		# Now load the audio stream
		var audio_stream = AudioStreamMP3.new()
		var file_data = FileAccess.open(file_path, FileAccess.READ)
		audio_stream.data = file_data.get_buffer(file_data.get_length())
		file_data.close()

		# Create and play the AudioStreamPlayer
		var player = AudioStreamPlayer.new()
		player.stream = audio_stream
		add_child(player)
		player.play()
	else:
		print("Error: ", response_code, " | ", body.get_string_from_utf8())
