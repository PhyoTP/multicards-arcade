extends Control

func _ready() -> void:
	$HBoxContainer/FlashcardsButton.pressed.connect(_button_pressed.bind("Flashcards"))
func _button_pressed(gamemode: String):
	Global.gamemode = gamemode
	get_tree().change_scene_to_file("res://SetSelect.tscn")
