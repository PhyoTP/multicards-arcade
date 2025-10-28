extends Control

var chosenSides: Dictionary = {_front=["Mixture"], _back=["Reaction"]}
var all_cards: Array = [{ "id": "36C88CA0-3E04-4E61-8C43-9FD2245D6C00", "sides": { "Mixture": "Acid + Metal", "Reaction": "salt + hydrogen gas" } }, { "id": "394B4B9A-71A3-4D62-9638-14FD99930D3D", "sides": { "Mixture": "Acid + Base", "Reaction": "salt + water" } }, { "id": "BD8B41B0-490B-4E34-A778-222AFA3580CF", "sides": { "Mixture": "Acid + metal carbonate", "Reaction": "salt + water + carbon dioxide" } }, { "id": "E612EF36-6DA6-4CB6-ADD2-C3D5AF698DAB", "sides": { "Mixture": "Base + ammonium salt", "Reaction": "salt + water + ammonia gas" } }]
var cards = all_cards
var index = 0
@onready var sub_side = preload("res://flashcardsubside.tscn")
@onready var card_button = $HBoxContainer/CardButton
@onready var k_button = $HBoxContainer/KnowButton
@onready var dk_button = $HBoxContainer/KnowButton2
var known = []
var dontKnown = []
var flipped = false
func _ready() -> void:
	print(cards)
	_set_card(chosenSides._front)
	card_button.pressed.connect(_flip_card)
	k_button.pressed.connect(_next.bind(true))
	dk_button.pressed.connect(_next.bind(false))
	$HBoxContainer2/RestartButton.pressed.connect(_restart.bind(false))
	$HBoxContainer2/RestartButton2.pressed.connect(_restart.bind(true))
func _set_card(sides: Array):
	for child in card_button.get_child(0).get_children():
		child.queue_free()
	for i in sides:
		var new_sub = sub_side.instantiate()
		new_sub.get_child(0).text = i
		new_sub.get_child(1).text = cards[index].sides[i]
		card_button.get_child(0).add_child(new_sub)
func _flip_card():
	if not flipped:
		_set_card(chosenSides._back)
	else:
		_set_card(chosenSides._front)
	flipped = !flipped
func _next(know: bool):
	if know:
		known.append(cards[index])
	else:
		dontKnown.append(cards[index])
	index += 1
	if index < cards.size():
		_set_card(chosenSides._front)
		flipped = false
	else: 
		$Label2.text = "You got " + str(all_cards.size()-dontKnown.size()) + " out of " + str(all_cards.size()) + " correct!"
		$HBoxContainer.visible = false
		$HBoxContainer2.visible = true
		$HBoxContainer2/RestartButton2.visible = dontKnown.size() > 0
		
func _restart(dk: bool):
	$HBoxContainer2.visible = false
	$HBoxContainer.visible = true
	$Label2.text = "Click to flip"
	index = 0
	if dk:
		cards = dontKnown
	else:
		cards = all_cards
	known = []
	dontKnown = []
	_set_card(chosenSides._front)
	flipped = false
