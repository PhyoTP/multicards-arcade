extends Control

var chosenSides: Dictionary = {_front=["Mixture"], _back=["Reaction"]}
var cards: Array = [{ "id": "36C88CA0-3E04-4E61-8C43-9FD2245D6C00", "sides": { "Mixture": "Acid + Metal", "Reaction": "salt + hydrogen gas" } }, { "id": "394B4B9A-71A3-4D62-9638-14FD99930D3D", "sides": { "Mixture": "Acid + Base", "Reaction": "salt + water" } }, { "id": "BD8B41B0-490B-4E34-A778-222AFA3580CF", "sides": { "Mixture": "Acid + metal carbonate", "Reaction": "salt + water + carbon dioxide" } }, { "id": "E612EF36-6DA6-4CB6-ADD2-C3D5AF698DAB", "sides": { "Mixture": "Base + ammonium salt", "Reaction": "salt + water + ammonia gas" } }]
var index = 0
@onready var sub_side = preload("res://flashcardsubside.tscn")
@onready var button = $HBoxContainer/Button
var flipped = false
func _ready() -> void:
	print(cards)
	_set_card(chosenSides._front)
	button.pressed.connect(_flip_card)
func _set_card(sides: Array):
	for i in sides:
		var new_sub = sub_side.instantiate()
		new_sub.get_child(0).text = i
		new_sub.get_child(1).text = cards[index].sides[i]
		button.get_child(0).add_child(new_sub)
func _flip_card():
	print("flipped")
	for child in button.get_child(0).get_children():
		child.queue_free()
	if not flipped:
		_set_card(chosenSides._back)
	else:
		_set_card(chosenSides._front)
	flipped = !flipped
