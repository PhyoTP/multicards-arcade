extends Control
@onready var list_button = preload("res://list_button.tscn")
@onready var status_label = $ScrollContainer/VBoxContainer/StatusLabel
func _ready():
	status_label.visible = true
	for child in $ScrollContainer/VBoxContainer.get_children():
		if child in get_tree().get_nodes_in_group("list_button"):
			child.queue_free()
	$HTTPRequest.request_completed.connect(_on_request_completed)
	var error = $HTTPRequest.request("https://api.phyotp.dev/multicards/sets")
	if error != OK:
		status_label.text = "Failed to load?! Reason unknown"
func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		status_label.visible = false
		var json: Array = JSON.parse_string(body.get_string_from_utf8())
		for item in json:
			var button = list_button.instantiate()
			button.cardSet = item
			$ScrollContainer/VBoxContainer.add_child(button)
	else:
		status_label.text = "Failed to load?! Error " + str(response_code)
		
		var image_loader = HTTPRequest.new()
		image_loader.request_completed.connect(_image_loaded)
		status_label.add_sibling(image_loader)
		image_loader.request("https://http.cat/"+str(response_code))
func _image_loaded(_result, response_code, _headers, body):
		if response_code == 200:
			var image = Image.new()
			image.load_jpg_from_buffer(body)
			var texture = ImageTexture.create_from_image(image)
			var texture_rect = TextureRect.new()
			status_label.add_sibling(texture_rect)
			texture_rect.texture = texture
