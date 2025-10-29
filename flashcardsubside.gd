extends VBoxContainer

var num: float = 1
func _ready() -> void:
	$Label.add_theme_font_size_override("font_size", 64/sqrt(num))
	$Label2.add_theme_font_size_override("font_size", 48/sqrt(num))
