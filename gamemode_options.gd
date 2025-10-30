extends Control

var id: String = "ee154f92-b537-490c-829b-c74f89d978ce"
var mode_categories = {
	"Flashcards": ["Front","Back", "Hint"],
	"Match": ["Sides"]
}
var mode_settings = {
	"Flashcards": ["shuffle"],
	"Match": []
}
var chosenSides: Dictionary
var cards: Array
var chosenSettings: Dictionary
func _ready() -> void:
	$StatusLabel.visible = true
	$Label.text = Global.gamemode
	var label = Label.new()
	label.text = "Attach this..."
	var offset = 0
	for i in mode_categories[Global.gamemode]:
		var node = GraphNode.new()
		node.title = i
		node.name = "_" + i
		node.position_offset = Vector2(0, offset)
		chosenSides["_"+i] = []
		node.add_child(label.duplicate())
		node.set_slot(0, false, 0, Color.DARK_ORANGE, true, 0, Color.DARK_ORANGE)
		$GraphEdit.add_child(node)
		offset += 64
	#$GraphEdit.scroll_offset = $GraphEdit.get_child(1).position_offset
	print($GraphEdit.get_child(1).position_offset)
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://api.phyotp.dev/multicards/set/"+id)
	$GraphEdit.connection_request.connect(_connect_node)
	$GraphEdit.disconnection_request.connect(_disconnect_node)
	$VBoxContainer/PlayButton.pressed.connect(_start)
	if "shuffle" in mode_settings[Global.gamemode]:
		$VBoxContainer/ShuffleButton.toggled.connect(func(new): chosenSettings.shuffle = new)
	else:
		$VBoxContainer/ShuffleButton.visible = false
	$GraphEdit.node_selected.connect(func(n): print(n.position_offset))
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
					newNode.position_offset = Vector2(476,offset)
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
	new_scene.all_cards = cards
	new_scene.chosenSettings = chosenSettings
	var old = preload("res://GamemodeOptions.tscn").instantiate()
	old.id = id
	Global.scene_path.append(old)
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene

	
