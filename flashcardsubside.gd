extends VBoxContainer


func _set_font_size(num: float):
	$Label.add_theme_font_size_override("font_size", 64/sqrt(num))
	$Label2.add_theme_font_size_override("font_size", 48/sqrt(num))
	$Label2.custom_minimum_size.x = 484/num
