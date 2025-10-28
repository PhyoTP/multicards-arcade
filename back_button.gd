extends Button

func _pressed() -> void:
	if Global.scene_path.is_empty():
		return # No history → avoid crash

	var last_entry = Global.scene_path.pop_back()

	if last_entry is PackedScene:
		# Scene stored as PackedScene reference
		_switch_to_scene(last_entry.instantiate())
	elif last_entry is Node:
		# Scene instance stored directly
		_switch_to_scene(last_entry)
	elif typeof(last_entry) == TYPE_STRING:
		# Scene stored by file path
		get_tree().change_scene_to_file(last_entry)

func _switch_to_scene(scene: Node) -> void:
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene
