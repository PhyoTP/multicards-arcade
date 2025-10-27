extends Control
@onready var list_button = preload("res://list_button.tscn")
func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://api.phyotp.dev/multicards/sets")

func _on_request_completed(result, response_code, headers, body):
	$LoadingLabel.visible = false
	var json: Array = JSON.parse_string(body.get_string_from_utf8())
	for item in json:
		var button = list_button.instantiate()
		button.cardSet = item
		$ScrollContainer/VBoxContainer.add_child(button)
