extends Control

var chosenSides: Dictionary = {_Front=["Mixture"], _Back=["Reaction"], _Hint=[]}
var all_cards: Array = [{ "id": "36C88CA0-3E04-4E61-8C43-9FD2245D6C00", "sides": { "Mixture": "Acid + Metal", "Reaction": "salt + hydrogen gas" } }, { "id": "394B4B9A-71A3-4D62-9638-14FD99930D3D", "sides": { "Mixture": "Acid + Base", "Reaction": "salt + water" } }, { "id": "BD8B41B0-490B-4E34-A778-222AFA3580CF", "sides": { "Mixture": "Acid + metal carbonate", "Reaction": "salt + water + carbon dioxide" } }, { "id": "E612EF36-6DA6-4CB6-ADD2-C3D5AF698DAB", "sides": { "Mixture": "Base + ammonium salt", "Reaction": "salt + water + ammonia gas" } }]
var cards: Array
var index = 0
@onready var sub_side = preload("res://flashcardsubside.tscn")
@onready var card_button = $HBoxContainer/CardButton
@onready var k_button = $HBoxContainer/KnowButton
@onready var dk_button = $HBoxContainer/KnowButton2
var known = []
var dontKnown = []
var flipped = false
var chosenSettings: Dictionary = {"shuffle":true}
var hint_shown = false
func _ready() -> void:
	cards = all_cards
	if chosenSettings.shuffle: cards.shuffle()
	_set_card(chosenSides._Front)
	card_button.pressed.connect(_flip_card)
	k_button.pressed.connect(_next.bind(true))
	dk_button.pressed.connect(_next.bind(false))
	$HBoxContainer2/RestartButton.pressed.connect(_restart.bind(false))
	$HBoxContainer2/RestartButton2.pressed.connect(_restart.bind(true))
	$HBoxContainer3/Label2.text = str(index+1) + "/" + str(cards.size())
	$HBoxContainer3/UndoButton.pressed.connect(_undo)
	$HintButton.visible = chosenSides._Hint.size() > 0
	$HintButton.pressed.connect(_show_hint)
func _set_card(sides: Array):
	for child in card_button.get_child(0).get_children():
		child.queue_free()
	for i in sides:
		var new_sub = sub_side.instantiate()
		new_sub.get_child(0).text = i
		new_sub.get_child(1).text = cards[index].sides[i]
		new_sub._set_font_size(sides.size())
		card_button.get_child(0).add_child(new_sub)
func _flip_card():
	if not flipped:
		_set_card(chosenSides._Back)
	else:
		_set_card(chosenSides._Front)
	flipped = !flipped
	hint_shown = false
func _next(know: bool):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	var old_card = card_button.duplicate()
	old_card.size = card_button.size
	old_card.global_position = card_button.global_position
	add_child(old_card)
	if know:
		known.append(cards[index])
		tween.tween_property(old_card,"position",Vector2(-576, 240), 0.3)
	else:
		dontKnown.append(cards[index])
		tween.tween_property(old_card,"position",Vector2(1152, 240), 0.3)
	index += 1
	if index < cards.size():
		_set_card(chosenSides._Front)
		$HBoxContainer3/Label2.text = str(index+1) + "/" + str(cards.size())
		$HBoxContainer3/UndoButton.disabled = index == 0
	else: 
		$Label2.text = "You got " + str(all_cards.size()-dontKnown.size()) + " out of " + str(all_cards.size()) + " correct!"
		$HBoxContainer.visible = false
		$HBoxContainer2.visible = true
		$HBoxContainer3/Label2.visible = false
		$HBoxContainer3/UndoButton.visible = false
		$HBoxContainer2/RestartButton2.visible = dontKnown.size() > 0
		$HintButton.visible = false
	flipped = false
	hint_shown = false
func _restart(dk: bool):
	$HBoxContainer2.visible = false
	$HBoxContainer.visible = true
	$HBoxContainer3/Label2.visible = true
	$HBoxContainer3/UndoButton.visible = true
	$HintButton.visible = chosenSides._Hint.size() > 0
	$HintButton.disabled = false
	$Label2.text = "Click to flip"
	index = 0
	if dk:
		cards = dontKnown
	else:
		cards = all_cards
	if chosenSettings.shuffle: cards.shuffle()
	$HBoxContainer3/Label2.text = str(index+1) + "/" + str(cards.size())
	known = []
	dontKnown = []
	_set_card(chosenSides._Front)
	$HBoxContainer3/UndoButton.disabled = true
func _undo():
	index -= 1
	known.erase(cards[index])
	dontKnown.erase(cards[index])
	_set_card(chosenSides._Front)
	$HBoxContainer3/UndoButton.disabled = index == 0
	flipped = false
	$HBoxContainer3/Label2.text = str(index+1) + "/" + str(cards.size())
func _show_hint():
	if not hint_shown:
		for i in chosenSides._Hint:
			var new_sub = sub_side.instantiate()
			new_sub.get_child(0).text = i
			new_sub.get_child(1).text = cards[index].sides[i]
			card_button.get_child(0).add_child(new_sub)
		for child in card_button.get_child(0).get_children():
			child._set_font_size(card_button.get_child(0).get_child_count())
		hint_shown = true
		
