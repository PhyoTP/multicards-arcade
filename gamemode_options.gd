extends Control

var id: String
var classic = ["Flashcards"]
var chosenSides: Dictionary
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
func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
		var sides = []
		var label = Label.new()
		label.text = "...to this"
		var offset = 0
		for card in json.cards:
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
	chosenSides[from].append(chosenSides)
	$GraphEdit.connect_node(from, find, to, tind)
func _disconnect_node(from, find, to, tind):
	chosenSides[from].erase(chosenSides)
	$GraphEdit.disconnect_node(from, find, to, tind)
