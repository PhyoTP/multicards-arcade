extends Control

func _ready() -> void:
	Global.scene_path.append("res://StartMenu.tscn")
	$HBoxContainer/FlashcardsButton.pressed.connect(_button_pressed.bind("Flashcards"))
func _button_pressed(gamemode: String):
	Global.gamemode = gamemode
	Global.scene_path.append(self.duplicate())
	get_tree().change_scene_to_file("res://SetSelect.tscn")
