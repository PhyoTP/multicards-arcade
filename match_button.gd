extends Button

var side = "Side"
var value = "Value"
func init(a_side: String, a_value: String) -> Button:
	side = a_side
	value = a_value
	$VBoxContainer/Label.text = side
	$VBoxContainer/Label2.text = value
	$VBoxContainer._set_font_size(3, 324)
	return self
func _pressed() -> void:
	$VBoxContainer/Label.add_theme_color_override("font_color", Color.WHITE)
func _unpress():
	$VBoxContainer/Label.remove_theme_color_override("font_color")


