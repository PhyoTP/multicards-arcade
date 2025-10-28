extends Control

var id: String = "b7507163-6612-455f-81a6-d29eb1634c97"
var classic = ["Flashcards"]
var chosenSides: Dictionary
var cards: Array
func _ready() -> void:
	$Label.text = Global.gamemode
	var label = Label.new()
	label.text = "Attach this..."
	if Global.gamemode in classic:
		var qFrame = GraphNode.new()
		qFrame.title = "Front"
		qFrame.name = "_front"
		chosenSides["_front"] = []
		qFrame.add_child(label)
		qFrame.set_slot(0, false, 0, Color.DARK_ORANGE, true, 0, Color.DARK_ORANGE)
		$GraphEdit.add_child(qFrame)
		var aFrame = GraphNode.new()
		aFrame.title = "Back"
		aFrame.name = "_back"
		chosenSides["_back"] = []
		aFrame.set_slot(0, false, 0, Color.DARK_ORANGE, true, 0, Color.DARK_ORANGE)
		aFrame.add_child(label.duplicate())
		$GraphEdit.add_child(aFrame)
	$GraphEdit.arrange_nodes()
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://api.phyotp.dev/multicards/set/"+id)
	$GraphEdit.connection_request.connect(_connect_node)
	$GraphEdit.disconnection_request.connect(_disconnect_node)
	$VBoxContainer/Button.pressed.connect(_start)
func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		$StatusLabel.visible = false
		var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
		var sides = []
		var label = Label.new()
		label.text = "...to this"
		var offset = 0
		cards = json.cards
		for card in cards:
			for side in card.sides:
				if side not in sides:
					sides.append(side)
					var newNode = GraphNode.new()
					newNode.title = side
					newNode.name = side
					newNode.position_offset = Vector2(576,offset)
					offset+=64
					newNode.add_child(label.duplicate())
					newNode.set_slot(0, true, 0, Color.DARK_ORANGE, false, 0, Color.DARK_ORANGE)
					$GraphEdit.add_child(newNode)
		
func _connect_node(from, find, to, tind):
	chosenSides[from].append(to)
	$GraphEdit.connect_node(from, find, to, tind)
func _disconnect_node(from, find, to, tind):
	chosenSides[from].erase(to)
	$GraphEdit.disconnect_node(from, find, to, tind)
func _start():
	var game_scene := load("res://"+Global.gamemode+".tscn")
	var new_scene = game_scene.instantiate()

	new_scene.chosenSides = chosenSides
	new_scene.cards = cards

	get_tree().root.add_child(new_scene)
	get_parent().remove_child(self)
	queue_free()

	
