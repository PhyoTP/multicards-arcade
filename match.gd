extends Control

@onready var match_button = preload("res://match_button.tscn")
var chosenSides: Dictionary = {_Sides=["Mixture","Reaction"]}
var all_cards: Array = [{ "id": "36C88CA0-3E04-4E61-8C43-9FD2245D6C00", "sides": { "Mixture": "Acid + Metal", "Reaction": "salt + hydrogen gas" } }, { "id": "394B4B9A-71A3-4D62-9638-14FD99930D3D", "sides": { "Mixture": "Acid + Base", "Reaction": "salt + water" } }, { "id": "BD8B41B0-490B-4E34-A778-222AFA3580CF", "sides": { "Mixture": "Acid + metal carbonate", "Reaction": "salt + water + carbon dioxide" } }, { "id": "E612EF36-6DA6-4CB6-ADD2-C3D5AF698DAB", "sides": { "Mixture": "Base + ammonium salt", "Reaction": "salt + water + ammonia gas" } }]
var cards: Array
var chosenSettings: Dictionary
var chosenButtons: Dictionary
var time = 0.0
var buttons = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cards = all_cards
	cards.shuffle()
	cards = cards.slice(0,4)
	$GridContainer.columns = chosenSides._Sides.size()
	for card in cards:
		for side in chosenSides._Sides:
			var button = match_button.instantiate()
			buttons.append(button.init(side,card.sides[side]))
	buttons.shuffle()
	for button in buttons:
		button.pressed.connect(_button_pressed.bind(button))
		$GridContainer.add_child(button)
	$Timer.timeout.connect(_timeout)
	$HBoxContainer/ScoreLabel.text = "0/" + str(cards.size())
	$RestartButton.pressed.connect(_restart)
func _button_pressed(button: Button):
	var unclick = false
	if chosenButtons.has(button.side):
		chosenButtons[button.side]._unpress()
		if chosenButtons[button.side] == button:
			chosenButtons.erase(button.side)
			unclick = true
	if not unclick:
		chosenButtons[button.side] = button
	if chosenSides._Sides.all(func(k): return chosenButtons.has(k)):
		for card in cards:
			if chosenButtons.keys().all(func(k): return chosenButtons[k].value == card.sides[k]):
				var tween = get_tree().create_tween().set_parallel()
				for b in chosenButtons:
					buttons.erase(chosenButtons[b])
					tween.tween_property(chosenButtons[b], "modulate", Color.TRANSPARENT, 0.5)
				$HBoxContainer/ScoreLabel.text = str(cards.size()-buttons.size()/chosenSides._Sides.size()) + "/" + str(cards.size())
				chosenButtons = {}
				tween.tween_callback(func():
					if buttons.size()==0:
						print("done")
						$Timer.stop()
						$RestartButton.visible = true
				)
				return
		print("wrong")
		for b in chosenButtons: chosenButtons[b]._unpress()
		chosenButtons = {}
func _timeout():
	time += 0.1
	$HBoxContainer/TimerLabel.text = "%0.1f" % time
func _restart():
	$RestartButton.visible = false
	time = 0.0
	$Timer.start()
	_ready()