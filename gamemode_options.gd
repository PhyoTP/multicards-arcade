extends Control

var id: String

func _ready() -> void:
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://api.phyotp.dev/multicards/set/"+id)
func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
		print(json)
