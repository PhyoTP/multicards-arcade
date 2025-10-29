extends Control

func _ready() -> void:
	$HBoxContainer/Button.pressed.connect(get_tree().change_scene_to_file.bind("res://ClassicGames.tscn"))
	$HBoxContainer2/AboutButton.pressed.connect(func(): $About.visible = true)
	$About.pressed.connect(func(): $About.visible = false)
	
