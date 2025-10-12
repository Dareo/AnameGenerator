extends Node

@onready var http_request := $HTTPRequestElevenLabs
var api_key = "sk_e2cb7b90f307c6afb038220d9ce027f7ef2ac34a48386acf"
var voice_id = "8PfKHL4nZToWC3pbz9U9"
#"8PfKHL4nZToWC3pbz9U9"
#"EXAVITQu4vr4xnSDxMaL"
#https://elevenlabs.io/app/voice-library?voiceId=RBnMinrYKeccY3vaUxlZ
# Time metrics
var talkTime = 0.0  # Estimated duration of the spoken audio
var responseDelay = 0.0  # Time from request sent → response received
var playbackStartDelay = 0.0  # Time from response received → audio actually starts
var totalDelay = 0.0  # Total time from request → audio starts

# Internal timestamp
var _requestStartTime = 0.0
var _responseTime = 0.0

func _ready():
	http_request.connect("request_completed", Callable(self, "_on_HTTPRequestElevenLabs_request_completed"))
	text_to_speech("Hello from Godot!")

func text_to_speech(text: String):
	_requestStartTime = Time.get_ticks_msec() / 1000.0  # Record start time in seconds

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
	var err = http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if err != OK:
		print("Request error: ", err)

func _on_HTTPRequestElevenLabs_request_completed(result, response_code, headers, body):
	_responseTime = Time.get_ticks_msec() / 1000.0
	responseDelay = _responseTime - _requestStartTime

	if response_code != 200:
		print("Request failed with code: ", response_code)
		return

	# Estimate talk time from MP3 byte size
	var mp3_byte_size = body.size()
	var bitrate_bps = 128000  # Assuming 128 kbps
	talkTime = float(mp3_byte_size * 8) / bitrate_bps

	# Set up and prepare audio player
	var audio_stream = AudioStreamMP3.new()
	audio_stream.data = body

	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = audio_stream

	# Wait one frame to ensure it's ready before measuring playback delay
	await get_tree().process_frame

	var playbackStartTime = Time.get_ticks_msec() / 1000.0
	playbackStartDelay = playbackStartTime - _responseTime
	totalDelay = playbackStartTime - _requestStartTime

	player.play()

	# Output all the timing info
	print("----------------------------")
	print("Talk time: ", "%.2f" % talkTime, " sec")
	print("Response delay: ", "%.2f" % responseDelay, " sec")
	print("Playback start delay: ", "%.2f" % playbackStartDelay, " sec")
	print("Total delay (request → play): ", "%.2f" % totalDelay, " sec")
	print("----------------------------")
